import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/connection/models/data_channel_message_model.dart';

import '../../wifi_direct/controllers/wifi_direct_wrapper.dart';
import 'connection_data_handler.dart';

enum ConnectivityStatus { connectionLost, connecting, justConnected, online }

abstract class ConnectionRepository {
  Rx<ConnectivityStatus> connectivityStatus = ConnectivityStatus.connecting.obs;

  void initConnection(
    MessageConnectionType messageConnectionType,
    String remoteId,
  );

  Future<void> sendTextMessage({
    required MessageConnectionType messageConnectionType,
    required String text,
    required String remoteCoreId,
  });

  Future<void> sendBinaryMessage({
    required Uint8List binary,
    required String remoteCoreId,
  });
}
