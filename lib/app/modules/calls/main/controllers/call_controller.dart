import 'package:get/get.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model.dart';
import 'package:heyo/app/modules/shared/data/models/call_view_arguments_model.dart';

class CallController extends GetxController {
  late CallViewArgumentsModel args;
  final participants = <UserModel>[].obs;
  @override
  void onInit() {
    super.onInit();
    args = Get.arguments as CallViewArgumentsModel;

    participants.add(args.user);
  }

  @override
  void onReady() {
    super.onReady();
  }

  // Todo
  void toggleMuteMic() {}

  // Todo
  void toggleMuteCall() {}

  // Todo
  void endCall() {}

  // Todo
  void addParticipant() {}

  // Todo
  void recordCall() {}

  // Todo
  void toggleVideo() {}

  // Todo
  void switchCamera() {}

  @override
  void onClose() {}
}
