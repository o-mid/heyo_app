import 'package:get/get.dart';

import '../controllers/incoming_call_controller.dart';
import 'package:heyo/app/modules/shared/bindings/global_bindings.dart';

class IncomingCallBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IncomingCallController>(
      () => IncomingCallController(
          callConnectionController: Get.find()),
    );
  }
}
