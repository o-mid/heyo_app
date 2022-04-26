import 'package:get/get.dart';

import '../controllers/forward_massages_controller.dart';

class ForwardMassagesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForwardMassagesController>(
      () => ForwardMassagesController(),
    );
  }
}
