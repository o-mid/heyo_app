import 'package:get/get.dart';

import '../controllers/generate_private_keys_controller.dart';

class GeneratePrivateKeysBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GeneratePrivateKeysController>(
      () => GeneratePrivateKeysController(),
    );
  }
}
