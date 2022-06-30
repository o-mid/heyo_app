import 'dart:async';

import 'package:ed_screen_recorder/ed_screen_recorder.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/call_controller/call_connection_controller.dart';
import 'package:heyo/app/modules/call_controller/call_state.dart';
import 'package:heyo/app/modules/calls/main/data/models/call_participant_model.dart';
import 'package:heyo/app/modules/calls/main/widgets/record_call_dialog.dart';
import 'package:heyo/app/modules/shared/data/models/call_view_arguments_model.dart';
import 'package:heyo/app/routes/app_pages.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:heyo/app/modules/p2p_node/p2p_state.dart';

enum CallViewType {
  stack,
  column,
  row,
}

enum RecordState {
  notRecording,
  loading,
  recording,
}

class CallController extends GetxController {
  late CallViewArgumentsModel args;
  final participants = <CallParticipantModel>[].obs;

  // Todo: check whether they are actually enabled or not
  final micEnabled = true.obs;
  final callerVideoEnabled = true.obs;

  final isInCall = true.obs;

  final calleeVideoEnabled = true.obs;

  final isImmersiveMode = false.obs;

  Timer? callTimer;
  final callDurationSeconds = 0.obs;

  // Todo: reset [callViewType] and [isVideoPositionsFlipped] when other user disables video
  final callViewType = CallViewType.stack.obs;

  final isVideoPositionsFlipped = false.obs;

  bool get isGroupCall =>
      participants
          .where((p) => p.status == CallParticipantStatus.inCall)
          .length >
      1;

  final recordState = RecordState.notRecording.obs;
  final CallConnectionController callConnectionController;
  final P2PState p2pState;

  CallController(
      {required this.callConnectionController, required this.p2pState});

  RTCVideoRenderer getRemoteVideRenderer() {
    return callConnectionController.getRemoteVideRenderer();
  }

  RTCVideoRenderer getLocalVideRenderer() {
    return callConnectionController.getLocalVideRenderer();
  }

  final _screenRecorder = EdScreenRecorder();

  @override
  void onInit() {
    super.onInit();

    args = Get.arguments as CallViewArgumentsModel;
    if (args.initiateCall) {
      final callId = DateTime.now().millisecondsSinceEpoch.toString();
      callConnectionController.startCall(args.user.walletAddress, callId);
      p2pState.callState.value = CallState.calling(callId);
      isInCall.value = false;
    } else {
      isInCall.value = true;

      p2pState.callState.value = CallState.inCall(args.callId!);
    }

    p2pState.callState.listen((state) {
      if (state is CallAccepted) {
        isInCall.value = true;
        callConnectionController.callAccepted(
            state.session, state.remoteCoreId, state.remotePeerId);
        p2pState.callState.value = CallState.inCall(state.callId);
      } else if (state is CallEnded) {
        Get.until((route) => Get.currentRoute != Routes.CALL);
      }
    });

    callConnectionController.callConnectionFailed.listen((ended) {
      if (ended) {
        Get.until((route) => Get.currentRoute != Routes.CALL);
      }
    });
    participants.add(
      CallParticipantModel(user: args.user),
    );
  }

  @override
  void onReady() {
    super.onReady();
  }

  // Todo
  void toggleMuteMic() {
    callConnectionController.muteMic();
    micEnabled.value = !micEnabled.value;
  }

  // Todo
  void toggleMuteCall() {}

  void endCall() {
    Get.back();
  }

  // Todo
  void addParticipant() {
    participants.add(
      CallParticipantModel(
        user: args.user,
        status: CallParticipantStatus.inCall,
      ),
    );
  }

  void recordCall() {
    Get.dialog(RecordCallDialog(onRecord: () async {
      recordState.value = RecordState.loading;
      var permission = await Permission.storage.request();
      if (!permission.isGranted) {
        recordState.value = RecordState.notRecording;
        return;
      }

      permission = await Permission.microphone.request();
      if (!permission.isGranted) {
        recordState.value = RecordState.notRecording;
        return;
      }
      await _screenRecorder.startRecordScreen(
        fileName: DateFormat('yMMddhhmmss').format(DateTime.now()),
        audioEnable: true,
      );
      recordState.value = RecordState.recording;
    }));
  }

  void stopRecording() async {
    await _screenRecorder.stopRecord();
    recordState.value = RecordState.notRecording;
  }

  // Todo
  void toggleVideo() {
    callerVideoEnabled.value = !callerVideoEnabled.value;
  }

  void switchCamera() {
    callConnectionController.switchCamera();
  }

  void toggleImmersiveMode() {
    isImmersiveMode.value = !isImmersiveMode.value;
  }

  void updateCallViewType(CallViewType type) => callViewType.value = type;

  void flipVideoPositions() =>
      isVideoPositionsFlipped.value = !isVideoPositionsFlipped.value;

  @override
  void onClose() async {
    callConnectionController.endCall();
    callTimer?.cancel();
    await _screenRecorder.stopRecord();
  }

  void reorderParticipants(int oldIndex, int newIndex) {
    final p = participants.removeAt(oldIndex);
    participants.insert(newIndex, p);
  }
}
