import 'package:get/get.dart';
import 'package:heyo/app/modules/p2p_node/p2p_node.dart';
import 'package:heyo/app/modules/p2p_node/p2p_node_manager.dart';
import 'package:heyo/app/routes/app_pages.dart';

class VerifiedUserController extends GetxController {
  P2PNodeController p2pNode;

  VerifiedUserController({required this.p2pNode});

  @override
  void onInit() {
    p2pNode.stop().then((value) => p2pNode.restart());
    super.onInit();
  }

  void buttonAction() => Get.offAllNamed(Routes.HOME);
}
