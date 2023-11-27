import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/data/repository/crypto_account/account_repository.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model/user_model.dart';
import 'package:heyo/app/modules/notifications/controllers/notifications_controller.dart';
import 'package:heyo/app/modules/shared/data/models/call_history_status.dart';
import 'package:heyo/app/modules/shared/data/models/incoming_call_view_arguments.dart';
import 'package:heyo/app/modules/shared/data/repository/contact_repository.dart';
import 'package:heyo/app/modules/calls/data/models.dart';
import 'package:heyo/app/modules/calls/data/rtc/multiple_call_connection_handler.dart';
import 'package:heyo/app/routes/app_pages.dart';

import '../notifications/controllers/notifications_controller.dart';
import '../shared/utils/constants/notifications_constant.dart';

class CallConnectionController extends GetxController {
  final CallConnectionsHandler callConnectionsHandler;

  final AccountRepository accountInfoRepo;
  final NotificationsController notificationsController;
  final ContactRepository contactRepository;
  final callState = Rxn<CallState>();
  final callHistoryState = Rxn<CallHistoryState>();
  final removeStream = Rxn<MediaStream>();

  Future<void> init() async {
    observeCallStatus();
  }

  void observeCallStatus() {
    callConnectionsHandler.onCallStateChange = (callId, calls, state) async {
      callState.value = state;

      callHistoryState.value = CallHistoryState(
        callId: callId,
        remotes: calls,
        callHistoryStatus: CallHistoryState.mapCallStateToCallHistoryStatus(state),
      );

      print("Call State changed, state is: $state");

      if (state == CallState.callStateRinging) {
        await handleCallStateRinging(callId: callId, calls: calls);
      } else if (state == CallState.callStateBye) {
        if (Get.currentRoute == Routes.CALL) {
          Get.until((route) => Get.currentRoute != Routes.CALL);
        } else if (Get.currentRoute == Routes.INCOMING_CALL) {
          Get.until((route) => Get.currentRoute != Routes.INCOMING_CALL);
        }
      }
    };
  }

  CallConnectionController(
      {required this.callConnectionsHandler,
      required this.accountInfoRepo,
      required this.notificationsController,
      required this.contactRepository}) {
    init();
  }

/*  Future<String> startCall(
      String remoteId, bool isAudioCall) async {
    String? selfCoreId = await accountInfo.getCoreId();
    final session =
        await callConnectionsHandler.requestCall(remoteId, isAudioCall);

    callHistoryState.value = CallHistoryState(
        callId: session.callId,
        remotes: [
          CallInfo(
              remotePeer:
                  RemotePeer(remotePeerId: null, remoteCoreId: remoteId),
              isAudioCall: isAudioCall)
        ],
        callHistoryStatus: CallHistoryStatus.initial);
    return session.callId;
  }*/
/*

  Future acceptCall(CallId callId) async {
    callConnectionsHandler.accept(callId);
    //callConnectionsHandler.accept(callId);

    */
/* callHistoryState.value = CallHistoryState(
        session: session, callHistoryStatus: CallHistoryStatus.connected);*/ /*

  }
*/

  /* void showLocalVideoStream(bool value, String? sessionId, bool sendSignal) {
    callConnectionsHandler.showLocalVideoStream(value);
    if (sendSignal == true && sessionId != null) {
      if (value == true) {
        callConnectionsHandler.peerOpendCamera(sessionId);
      } else {
        callConnectionsHandler.peerClosedCamera(sessionId);
      }
    }
  }*/
/*

  void rejectCall(CallId callId) {
    callConnectionsHandler.reject(callId);
    //TODO update
    */
/* callHistoryState.value = CallHistoryState(
        session: session, callHistoryStatus: CallHistoryStatus.connected);*/ /*

  }

*/

/*
  void endOrCancelCall(CallId callId) {
    callConnectionsHandler.reject(callId);
    //TODO farzam
    */ /*callHistoryState.value = CallHistoryState(
        session: session, callHistoryStatus: CallHistoryStatus.byeSent);*/ /*
  }*/

  Future<void> handleCallStateRinging({
    required CallId callId,
    required List<CallInfo> calls,
  }) async {
    UserModel? userModel = await contactRepository
        .getContactById(calls.first.remotePeer.remoteCoreId);
    await notifyReceivedCall(callInfo: calls.first);

    await Get.toNamed(
      Routes.INCOMING_CALL,
      arguments: IncomingCallViewArguments(
        callId: callId,
        isAudioCall: calls.first.isAudioCall,
        members: calls.map((e) => e.remotePeer.remoteCoreId).toList(),
      ),
    );
  }

  Future<void> notifyReceivedCall({required CallInfo callInfo}) async {
    await notificationsController.receivedCallNotify(
      title: "Incoming ${callInfo.isAudioCall ? "Audio" : "Video"} Call",
      body:
          "from ${callInfo.remotePeer.remoteCoreId.characters.take(4).string}...${callInfo.remotePeer.remoteCoreId.characters.takeLast(4).string}",
    );
  }

  /* List<MediaStream > getRemoteStreams(CallId callId) {
    return callConnectionsHandler.getRemoteStreams();
  }*/
}
