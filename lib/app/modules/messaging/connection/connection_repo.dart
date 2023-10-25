import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:heyo/app/modules/messaging/multiple_connections.dart';

import '../../wifi_direct/controllers/wifi_direct_wrapper.dart';
import 'connection_data_handler.dart';

enum ConnectivityStatus { connectionLost, connecting, justConnected, online }

abstract class ConnectionRepo {
  ConnectionRepo({required this.dataHandler});
  final DataHandler dataHandler;
  Rx<ConnectivityStatus> connectivityStatus = ConnectivityStatus.connecting.obs;
  Future<void> initMessagingConnection({
    required String remoteId,
    MultipleConnectionHandler? multipleConnectionHandler,
  });
  Future<void> initConnection({
    MultipleConnectionHandler? multipleConnectionHandler,
    WifiDirectWrapper? wifiDirectWrapper,
  });

  Future<void> sendTextMessage({required String text, required String remoteCoreId});
  Future<void> sendBinaryMessage({required Uint8List binary, required String remoteCoreId});
}
