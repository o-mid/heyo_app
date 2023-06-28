import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/p2p_node/data/account/account_info.dart';
import 'package:heyo/app/modules/shared/data/models/call_history_status.dart';
import 'package:heyo/app/modules/shared/data/models/incoming_call_view_arguments.dart';
import 'package:heyo/app/modules/web-rtc/signaling.dart';
import 'package:heyo/app/routes/app_pages.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../notifications/controllers/notifications_controller.dart';
import '../shared/utils/constants/notifications_constant.dart';

class CallConnectionController extends GetxController {
  final Signaling signaling;
  final AccountInfo accountInfo;

  final callState = Rxn<CallState>();
  final callHistoryState = Rxn<CallHistoryState>();
  final remoteStream = Rxn<MediaStream>();
  final removeStream = Rxn<MediaStream>();
  final localStream = Rxn<MediaStream>();

  MediaStream? _localStream;

  @override
  void onInit() {
    super.onInit();
    init();
  }

  MediaStream? getLocalStream() => _localStream;

  Future<void> init() async {
    signaling.onLocalStream = ((stream) {
      _localStream = stream;
      localStream.value = stream;
    });

    observeCallStatus();
  }

  void observeCallStatus() {
    signaling.onCallStateChange = (session, state) async {
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
    signaling.onAddRemoteStream = (session, stream) async {
      remoteStream.value = stream;
    };
    signaling.onRemoveRemoteStream = (session, stream) async {
      removeStream.value = stream;
    };
  }

  CallConnectionController({required this.signaling, required this.accountInfo});

  Future<Session> startCall(String remoteId, String callId, bool isAudioCall) async {
    String? selfCoreId = await accountInfo.getCoreId();
    final session = await signaling.invite(remoteId, 'video', false, selfCoreId!, isAudioCall);

    callHistoryState.value =
        CallHistoryState(session: session, callHistoryStatus: CallHistoryStatus.initial);
    return session;
  }

  Future acceptCall(Session session) async {
    signaling.accept(
      session.sid,
    );

    callHistoryState.value =
        CallHistoryState(session: session, callHistoryStatus: CallHistoryStatus.connected);
  }

  void switchCamera() {
    signaling.switchCamera();
  }

  void muteMic() {
    signaling.muteMic();
  }

  void showLocalVideoStream(bool value, String? sessionId, bool sendSignal) {
    signaling.showLocalVideoStream(value);
    if (sendSignal == true && sessionId != null) {
      if (value == true) {
        signaling.peerOpendCamera(sessionId);
      } else {
        signaling.peerClosedCamera(sessionId);
      }
    }
  }

  void rejectCall(Session session) {
    signaling.reject(session);
    callHistoryState.value =
        CallHistoryState(session: session, callHistoryStatus: CallHistoryStatus.connected);
  }

  void close() {
    signaling.close();
    localStream.value = null;
  }

  void endOrCancelCall(Session session) {
    signaling.reject(session);
    callHistoryState.value =
        CallHistoryState(session: session, callHistoryStatus: CallHistoryStatus.byeSent);
  }

  Future<void> handleCallStateRinging({required Session session}) async {
    try {
      await notifyReceivedCall(callSession: session);
    } catch (e) {
      print(e);
    }

    await Get.toNamed(
      Routes.INCOMING_CALL,
      arguments: IncomingCallViewArguments(
        session: session,
        callId: "",
        sdp: session.sid,
        remoteCoreId: session.cid,
        remotePeerId: session.pid!,
      ),
    );
  }

  Future<void> notifyReceivedCall({
    required Session callSession,
  }) async {
    await Get.find<NotificationsController>().receivedCallNotify(
      channelKey: NOTIFICATIONS.callsChannelKey,
      title: "Incoming ${callSession.isAudioCall ? "Audio" : "Video"} Call",
      body:
          "from ${callSession.cid.characters.take(4).string}...${callSession.cid.characters.takeLast(4).string}",
    );
  }
}
