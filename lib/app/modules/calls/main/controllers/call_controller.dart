import 'dart:async';

import 'package:get/get.dart';
import 'package:heyo/app/modules/call_controller/call_controller.dart';
import 'package:heyo/app/modules/call_controller/call_state.dart';
import 'package:heyo/app/modules/calls/main/data/models/call_participant_model.dart';
import 'package:heyo/app/modules/calls/main/widgets/record_call_dialog.dart';
import 'package:heyo/app/modules/shared/data/models/call_view_arguments_model.dart';
import 'package:heyo/app/modules/p2p_node/p2p_state.dart';
import 'package:heyo/app/modules/shared/utils/extensions/string.extension.dart';

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
      participants
          .where((p) => p.status == CallParticipantStatus.inCall)
          .length >
      1;

  final recordState = RecordState.notRecording.obs;
  final CallConnectionController callConnectionController;
  final P2PState p2pState;

  CallController(
      {required this.callConnectionController, required this.p2pState});

  @override
  void onInit() {
    super.onInit();

    args = Get.arguments as CallViewArgumentsModel;
    callConnectionController.startCall(args.user.walletAddress);
    p2pState.callState.value=CallState.calling();

    p2pState.callState.listen((state) {
      if (state is CallAccepted) {
        callConnectionController.callAccepted(state.session.convertHexToString());
      }
    });
    participants.add(
      CallParticipantModel(user: args.user),
    );

    // Todo (remove): this is only for testing purposes
    Future.delayed(const Duration(seconds: 1), () {
      participants[0] =
          participants[0].copyWith(status: CallParticipantStatus.inCall);
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

  // Todo
  void recordCall() {
    Get.dialog(RecordCallDialog(onRecord: () {
      recordState.value = RecordState.loading;
      Future.delayed(const Duration(seconds: 2),
          () => recordState.value = RecordState.recording);
    }));
  }

  // Todo
  void stopRecording() {
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

  void flipVideoPositions() =>
      isVideoPositionsFlipped.value = !isVideoPositionsFlipped.value;

  @override
  void onClose() {
    callTimer?.cancel();
  }

  void reorderParticipants(int oldIndex, int newIndex) {
    final p = participants.removeAt(oldIndex);
    participants.insert(newIndex, p);
  }
}
