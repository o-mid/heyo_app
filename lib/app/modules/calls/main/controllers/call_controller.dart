import 'dart:async';

import 'package:get/get.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model.dart';
import 'package:heyo/app/modules/shared/data/models/call_view_arguments_model.dart';

class CallController extends GetxController {
  late CallViewArgumentsModel args;
  final participants = <UserModel>[].obs;
  // Todo: check whether they are actually enabled or not
  final micEnabled = true.obs;
  final callerVideoEnabled = true.obs;

  final isCallInProgress = false.obs;

  final calleeVideoEnabled = true.obs;

  final isImmersiveMode = false.obs;

  Timer? callTimer;
  final callDurationSeconds = 0.obs;
  @override
  void onInit() {
    super.onInit();
    args = Get.arguments as CallViewArgumentsModel;

    Future.delayed(const Duration(seconds: 1), () {
      isCallInProgress.value = true;
      callTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        callDurationSeconds.value++;
      });
    });

    participants.add(args.user);
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
  void addParticipant() {}

  // Todo
  void recordCall() {}

  // Todo
  void toggleVideo() {
    callerVideoEnabled.value = !callerVideoEnabled.value;
  }

  // Todo
  void switchCamera() {}

  void toggleImmersiveMode() {
    isImmersiveMode.value = !isImmersiveMode.value;
  }

  @override
  void onClose() {
    callTimer?.cancel();
  }
}
