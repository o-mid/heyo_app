import 'package:get/get.dart';
import 'package:heyo/app/modules/home/controllers/home_controller.dart';

import 'package:heyo/app/modules/shared/bindings/global_bindings.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(
          p2pState: GlobalBindings.p2pState),
    );
  }
}
