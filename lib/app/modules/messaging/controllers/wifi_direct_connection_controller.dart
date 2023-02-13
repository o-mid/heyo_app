import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import 'common_messaging_controller.dart';
import 'messaging_connection_controller.dart';

// Todo :  change this status names if needed base on the connection status of the wifi direct
enum WifiDirectConnectivityStatus { connectionLost, connecting, justConnected, online }

class WifiDirectConnectionController extends CommonMessagingConnectionController {
  Rx<WifiDirectConnectivityStatus> wifiDirectStatus = WifiDirectConnectivityStatus.connecting.obs;

  WifiDirectConnectionController({required super.accountInfo, required super.messagesRepo, required super.chatHistoryRepo});

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
