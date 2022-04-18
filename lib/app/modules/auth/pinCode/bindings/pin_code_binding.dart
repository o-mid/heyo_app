import 'package:get/get.dart';

import '../controllers/pin_code_controller.dart';

class PinCodeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PinCodeController>(
      () => PinCodeController(),
    );
  }
}
