import 'package:get/get.dart';

import '../controllers/generat_private_keys_controller.dart';

class GeneratPrivateKeysBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GeneratPrivateKeysController>(
      () => GeneratPrivateKeysController(),
    );
  }
}
