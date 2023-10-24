import 'dart:typed_data';

import 'package:heyo/app/modules/messaging/multiple_connections.dart';

import 'connection_data_handler.dart';

abstract class ConnectionRepo {
  final DataHandler dataHandler;

  ConnectionRepo({required this.dataHandler});
  Future<void> initMessagingConnection({
    required String remoteId,
    MultipleConnectionHandler? multipleConnectionHandler,
  });
  Future<void> initConnection({
    MultipleConnectionHandler? multipleConnectionHandler,
  });

  Future<void> sendTextMessage({required String text, required String remoteCoreId});
  Future<void> sendBinaryMessage({required Uint8List binary, required String remoteCoreId});
}
