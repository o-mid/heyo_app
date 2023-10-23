import 'dart:typed_data';

import 'package:heyo/app/modules/messaging/multiple_connections.dart';

abstract class ConnectionRepo {
  Future<void> initMessagingConnection({
    required String remoteId,
  });
  Future<void> initConnection({
    MultipleConnectionHandler multipleConnectionHandler,
  });

  Future<void> sendTextMessage({required String text, required String remoteCoreId});
  Future<void> sendBinaryMessage({required Uint8List binary, required String remoteCoreId});
}
