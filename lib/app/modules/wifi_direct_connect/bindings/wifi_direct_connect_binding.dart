import 'package:get/get.dart';

import '../../messaging/controllers/wifi_direct_connection_controller.dart';
import '../../messaging/unified_messaging_controller.dart';
import '../controllers/wifi_direct_connect_controller.dart';

class WifiDirectConnectBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WifiDirectConnectController>(
      () => WifiDirectConnectController(
        wifiDirectConnectionController: Get.find<UnifiedConnectionController>(),
      ),
    );
  }
}
