import 'package:get/get.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model.dart';
import 'package:heyo/app/modules/shared/data/models/call_view_arguments_model.dart';
import 'package:heyo/app/routes/app_pages.dart';

class IncomingCallController extends GetxController {
  late UserModel caller;
  final muted = false.obs;

  @override
  void onInit() {
    super.onInit();

    caller = UserModel(
      name: "Boiled Dancer",
      icon: "https://avatars.githubusercontent.com/u/6645136?v=4",
      isVerified: true,
      walletAddress: "CB11${List.generate(10, (index) => index)}14AB",
    );
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  void goToChat() {
    _hangUp();
    // Todo: go to user chat
  }

  void mute() {
    muted.value = true;
    // Todo: stop ringtone
  }

  void declineCall() {
    _hangUp();
    Get.back();
  }

  void acceptCall() {
    Get.offNamed(Routes.CALL, arguments: CallViewArgumentsModel(user: caller));
  }

  void _hangUp() {
    // Todo
  }
}
