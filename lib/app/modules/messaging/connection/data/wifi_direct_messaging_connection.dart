import 'dart:typed_data';

import 'package:heyo/app/modules/messaging/connection/domain/messaging_connection.dart';
import 'package:heyo/app/modules/messaging/connection/domain/messaging_connections_models.dart';
import 'package:heyo/app/modules/messaging/models/data_channel_message_model.dart';

import '../connection_repo.dart';

//TODO wifi-direct
class WifiDirectMessagingConnection extends ConnectionRepository {
  @override
  void initConnection(MessageConnectionType messageConnectionType, String remoteId) {
    // TODO: implement initConnection
  }

  @override
  Future<void> sendBinaryMessage({required Uint8List binary, required String remoteCoreId}) {
    // TODO: implement sendBinaryMessage
    throw UnimplementedError();
  }

  @override
  Future<void> sendTextMessage(
      {required MessageConnectionType messageConnectionType,
      required String text,
      required String remoteCoreId}) {
    // TODO: implement sendTextMessage
    throw UnimplementedError();
  }
}
