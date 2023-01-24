import 'package:get/get.dart';

import '../controllers/wifi_direct_controller.dart';

class WifiDirectBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WifiDirectController>(
      () => WifiDirectController(),
    );
  }
}
