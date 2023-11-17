import 'package:get/get.dart';

import '../controllers/call_controller.dart';
import 'package:heyo/app/modules/shared/bindings/global_bindings.dart';

class CallBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CallController>(
      () => CallController(
        callConnectionController: Get.find(),
        notificationProvider: Get.find(),
      ),
    );
  }
}
