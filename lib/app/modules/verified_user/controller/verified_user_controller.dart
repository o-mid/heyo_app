import 'package:get/get.dart';
import 'package:heyo/app/modules/p2p_node/p2p_node.dart';
import 'package:heyo/app/modules/p2p_node/p2p_node_manager.dart';
import 'package:heyo/app/routes/app_pages.dart';

class VerifiedUserController extends GetxController {
  VerifiedUserController();

  @override
  void onInit() {
    super.onInit();
  }

  void buttonAction() => Get.offAllNamed(Routes.HOME);
}
