import 'package:get/get_state_manager/src/simple/get_controllers.dart';

enum WifiDirectConnectivityStatus { connectionLost, connecting, justConnected, online }

class WifiDirectConnectionController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  // TODO:

  initWifiDirectMessaging() async {
    print("init Wifi Direct Messaging");
  }
}
