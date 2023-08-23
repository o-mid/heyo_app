import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model.dart';
import 'package:heyo/app/modules/p2p_node/data/account/account_info.dart';
import 'package:heyo/app/modules/shared/data/models/call_history_status.dart';
import 'package:heyo/app/modules/shared/data/models/incoming_call_view_arguments.dart';
import 'package:heyo/app/modules/shared/data/repository/contact_repository.dart';
import 'package:heyo/app/modules/web-rtc/multiple_call_connection_handler.dart';
import 'package:heyo/app/modules/web-rtc/signaling.dart';
import 'package:heyo/app/routes/app_pages.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../notifications/controllers/notifications_controller.dart';
import '../shared/utils/constants/notifications_constant.dart';

class CallConnectionController extends GetxController {
  final CallConnectionsHandler callConnectionsHandler;
  final AccountInfo accountInfo;
  final NotificationsController notificationsController;
  final ContactRepository contactRepository;
  final callState = Rxn<CallState>();
  final callHistoryState = Rxn<CallHistoryState>();
  final removeStream = Rxn<MediaStream>();
  Function(MediaStream stream)? onLocalStream;
  Function(MediaStream stream)? onAddRemoteStream;

  MediaStream? _localStream;

  @override
  void onInit() {
    super.onInit();
    init();
  }

  MediaStream? getLocalStream() => _localStream;

  Future<void> init() async {
    callConnectionsHandler.onLocalStream = ((stream) {
      _localStream = stream;
      onLocalStream?.call(stream);
    });

    observeCallStatus();
  }

  void observeCallStatus() {
    callConnectionsHandler.onCallStateChange = (session, state) async {
      callState.value = state;

      callHistoryState.value = CallHistoryState(
        session: session,
        callHistoryStatus: CallHistoryState.mapCallStateToCallHistoryStatus(state),
      );

      print("Call State changed, state is: $state");

      if (state == CallState.callStateRinging) {
        await handleCallStateRinging(session: session);
      } else if (state == CallState.callStateBye) {
        if (Get.currentRoute == Routes.CALL) {
          Get.until((route) => Get.currentRoute != Routes.CALL);
        } else if (Get.currentRoute == Routes.INCOMING_CALL) {
          Get.until((route) => Get.currentRoute != Routes.INCOMING_CALL);
        }
      }
    };
    callConnectionsHandler.onAddRemoteStream = (session, stream) async {
      onAddRemoteStream?.call(stream);
    };
    callConnectionsHandler.onRemoveRemoteStream = (session, stream) async {
      removeStream.value = stream;
    };
  }

  CallConnectionController(
      {required this.callConnectionsHandler,
      required this.accountInfo,
      required this.notificationsController,
      required this.contactRepository});

  Future<Session> startCall(String remoteId, String callId, bool isAudioCall) async {
    String? selfCoreId = await accountInfo.getCoreId();
    final session = await callConnectionsHandler.invite(remoteId, 'video', false, selfCoreId!, isAudioCall);

    callHistoryState.value =
        CallHistoryState(session: session, callHistoryStatus: CallHistoryStatus.initial);
    return session;
  }

  Future acceptCall(Session session) async {
    callConnectionsHandler.accept(
      session.sid,
    );

    callHistoryState.value =
        CallHistoryState(session: session, callHistoryStatus: CallHistoryStatus.connected);
  }

  void switchCamera() {
    callConnectionsHandler.switchCamera();
  }

  void muteMic() {
    callConnectionsHandler.muteMic();
  }

  void showLocalVideoStream(bool value, String? sessionId, bool sendSignal) {
    callConnectionsHandler.showLocalVideoStream(value);
    if (sendSignal == true && sessionId != null) {
      if (value == true) {
        callConnectionsHandler.peerOpendCamera(sessionId);
      } else {
        callConnectionsHandler.peerClosedCamera(sessionId);
      }
    }
  }

  void rejectCall(Session session) {
    callConnectionsHandler.reject(session);
    callHistoryState.value =
        CallHistoryState(session: session, callHistoryStatus: CallHistoryStatus.connected);
  }

  Future<void> close() async {
    await callConnectionsHandler.close();
    onLocalStream = null;
    onAddRemoteStream = null;
  }

  void endOrCancelCall(Session session) {
    callConnectionsHandler.reject(session);
    callHistoryState.value =
        CallHistoryState(session: session, callHistoryStatus: CallHistoryStatus.byeSent);
  }

  Future<void> handleCallStateRinging({required Session session}) async {
    UserModel? userModel = await contactRepository.getContactById(session.cid);
    await notifyReceivedCall(callSession: session);

    await Get.toNamed(
      Routes.INCOMING_CALL,
      arguments: IncomingCallViewArguments(
          session: session,
          callId: "",
          sdp: session.sid,
          remoteCoreId: session.cid,
          remotePeerId: session.pid!,
          name: userModel?.name),
    );
  }

  Future<void> notifyReceivedCall({
    required Session callSession,
  }) async {
    await notificationsController.receivedCallNotify(
      title: "Incoming ${callSession.isAudioCall ? "Audio" : "Video"} Call",
      body:
          "from ${callSession.cid.characters.take(4).string}...${callSession.cid.characters.takeLast(4).string}",
    );
  }
}
