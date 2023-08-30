import 'package:get/get.dart';
import 'package:heyo/app/modules/verified_user/controller/verified_user_controller.dart';

class VerifiedUserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VerifiedUserController>(
      () => VerifiedUserController(),
    );
  }
}
