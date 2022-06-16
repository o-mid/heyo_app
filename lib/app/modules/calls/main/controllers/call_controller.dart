import 'dart:async';

import 'package:ed_screen_recorder/ed_screen_recorder.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/main/data/models/call_participant_model.dart';
import 'package:heyo/app/modules/calls/main/widgets/record_call_dialog.dart';
import 'package:heyo/app/modules/shared/data/models/call_view_arguments_model.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

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

  final isCallInProgress = false.obs;

  final calleeVideoEnabled = true.obs;

  final isImmersiveMode = false.obs;

  Timer? callTimer;
  final callDurationSeconds = 0.obs;

  // Todo: reset [callViewType] and [isVideoPositionsFlipped] when other user disables video
  final callViewType = CallViewType.stack.obs;

  final isVideoPositionsFlipped = false.obs;

  bool get isGroupCall =>
      participants.where((p) => p.status == CallParticipantStatus.inCall).length > 1;

  final recordState = RecordState.notRecording.obs;

  final _screenRecorder = EdScreenRecorder();

  @override
  void onInit() {
    super.onInit();
    args = Get.arguments as CallViewArgumentsModel;

    participants.add(
      CallParticipantModel(user: args.user),
    );

    // Todo (remove): this is only for testing purposes
    Future.delayed(const Duration(seconds: 1), () {
      participants[0] = participants[0].copyWith(status: CallParticipantStatus.inCall);
      isCallInProgress.value = true;
      callTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        callDurationSeconds.value++;
      });
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  // Todo
  void toggleMuteMic() {
    micEnabled.value = !micEnabled.value;
  }

  // Todo
  void toggleMuteCall() {}

  // Todo
  void endCall() {}

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

  // Todo
  void switchCamera() {}

  void toggleImmersiveMode() {
    isImmersiveMode.value = !isImmersiveMode.value;
  }

  void updateCallViewType(CallViewType type) => callViewType.value = type;

  void flipVideoPositions() => isVideoPositionsFlipped.value = !isVideoPositionsFlipped.value;

  @override
  void onClose() async {
    callTimer?.cancel();
    await _screenRecorder.stopRecord();
  }

  void reorderParticipants(int oldIndex, int newIndex) {
    final p = participants.removeAt(oldIndex);
    participants.insert(newIndex, p);
  }
}
