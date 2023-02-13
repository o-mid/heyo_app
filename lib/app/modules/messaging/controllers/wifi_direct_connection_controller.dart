import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import 'messaging_connection_controller.dart';

// Todo :  change this status names if needed base on the connection status of the wifi direct
enum WifiDirectConnectivityStatus { connectionLost, connecting, justConnected, online }

class WifiDirectConnectionController extends CommonMessagingController {
  Rx<WifiDirectConnectivityStatus> wifiDirectStatus = WifiDirectConnectivityStatus.connecting.obs;

  @override
  void onInit() {
    super.onInit();
  }


  @override
  Future<void> initMessagingConnection({required String remoteId}) async {
  }

  @override
  Future<void> sendTextMessage({required String text}) async {
  }

  @override
  Future<void> sendBinaryMessage({required Uint8List binary}) async {
  }

}
