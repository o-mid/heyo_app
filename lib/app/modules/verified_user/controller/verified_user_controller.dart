import 'package:get/get.dart';
import 'package:heyo/app/modules/connection/domain/connection_contractor.dart';
import 'package:heyo/app/routes/app_pages.dart';

class VerifiedUserController extends GetxController {
  VerifiedUserController();

  @override
  void onInit() {
    super.onInit();
  }

  void buttonAction() => Get.offAllNamed(Routes.HOME);
}
