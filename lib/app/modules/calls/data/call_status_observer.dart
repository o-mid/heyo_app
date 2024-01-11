import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/data/call_status_provider.dart';
import 'package:heyo/app/modules/calls/data/rtc/models.dart';
import 'package:heyo/app/modules/calls/data/rtc/multiple_call_connection_handler.dart';
import 'package:heyo/app/modules/notifications/controllers/notifications_controller.dart';
import 'package:heyo/app/modules/shared/data/models/call_history_status.dart';
import 'package:heyo/app/modules/shared/data/models/incoming_call_view_arguments.dart';
import 'package:heyo/app/modules/shared/data/repository/contact_repository.dart';
import 'package:heyo/app/modules/shared/data/repository/crypto_account/account_repository.dart';
import 'package:heyo/app/modules/shared/utils/extensions/stream.extension.dart';
import 'package:heyo/app/modules/shared/widgets/snackbar_widget.dart';
import 'package:heyo/app/routes/app_pages.dart';
import 'package:heyo/main.dart';

class CallStatusObserver extends GetxController with WidgetsBindingObserver {
  CallStatusObserver({
    required this.callStatusProvider,
    required this.accountInfoRepo,
    required this.notificationsController,
    required this.contactRepository,
  }) {
    init();
  }

  final Rx<AppLifecycleState> _appState = Rx(AppLifecycleState.resumed);

  //final CallConnectionsHandler callConnectionsHandler;
  final CallStatusProvider callStatusProvider;
  final AccountRepository accountInfoRepo;
  final NotificationsController notificationsController;
  final ContactRepository contactRepository;
  final callHistoryState = Rxn<CallHistoryState>();
  final removeStream = Rxn<MediaStream>();

  Future<void> init() async {
    observeCallStatus();
    WidgetsBinding.instance.addObserver(this);
  }

  void observeCallStatus() {
    callStatusProvider
      ..onCallHistoryStatusEvent = (callId, call, state, isAudioCall) async {
        callHistoryState.value = CallHistoryState(
            callId: callId,
            remote: call,
            callHistoryStatus: state,
            isAudioCall: isAudioCall);
      }
      ..onCallStateChange = (callId, calls, state) async {
        print('Call State changed, state is: $state');
        if (state == CurrentCallStatus.inComingCall) {
          await handleCallStateRinging(callId: callId, calls: calls);
        }
        if (state == CurrentCallStatus.end) {
          if (Get.currentRoute == Routes.CALL) {
            Get.until((route) => Get.currentRoute != Routes.CALL);
          } else if (Get.currentRoute == Routes.INCOMING_CALL) {
            Get.until((route) => Get.currentRoute != Routes.INCOMING_CALL);
          }
        }
        /*  if (state == CallState.callStateRinging) {

        } else if (state == CallState.callStateBye) {
          if (Get.currentRoute == Routes.CALL) {
            Get.until((route) => Get.currentRoute != Routes.CALL);
          } else if (Get.currentRoute == Routes.INCOMING_CALL) {
            Get.until((route) => Get.currentRoute != Routes.INCOMING_CALL);
          }
        }*/
      };
  }

  Future<void> handleCallStateRinging({
    required CallId callId,
    required List<CallInfo> calls,
  }) async {
    final userModel = await contactRepository
        .getContactById(calls.first.remotePeer.remoteCoreId);

    await waitForApplicationStatus();

    await Get.toNamed(
      Routes.INCOMING_CALL,
      arguments: IncomingCallViewArguments(
        callId: callId,
        isAudioCall: calls.first.isAudioCall,
        members: calls.map((e) => e.remotePeer.remoteCoreId).toList(),
      ),
    );
  }

  Future<void> _notifyReceivedCall({required CallInfo callInfo}) async {
    await notificationsController.receivedCallNotify(
      title: "Incoming ${callInfo.isAudioCall ? "Audio" : "Video"} Call",
      body:
          'from ${callInfo.remotePeer.remoteCoreId.characters.take(4).string}...${callInfo.remotePeer.remoteCoreId.characters.takeLast(4).string}',
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _appState.value = state;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> waitForApplicationStatus() async {
    if (_appState.value.name != AppLifecycleState.resumed.name) {
      await _appState.stream.waitForResult(
          condition: (AppLifecycleState value) {
        return value.name == AppLifecycleState.resumed.name;
      });
    }
  }
}
