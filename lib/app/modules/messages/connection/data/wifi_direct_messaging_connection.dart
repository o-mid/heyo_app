import 'dart:typed_data';

import 'package:heyo/app/modules/messages/connection/domain/messaging_connection.dart';
import 'package:heyo/app/modules/messages/connection/domain/messaging_connections_models.dart';
import 'package:heyo/app/modules/messages/connection/models/data_channel_message_model.dart';

import '../connection_repo.dart';

//TODO wifi-direct
class WifiDirectMessagingConnection extends MessagingConnection {
  @override
  Stream<MessagingConnectionStatus> getConnectionStatus() {
    // TODO: implement getConnectionStatus
    throw UnimplementedError();
  }

  @override
  Stream<MessagingConnectionReceivedData> getMessageStream() {
    // TODO: implement getMessageStream
    throw UnimplementedError();
  }

  @override
  void init(MessagingConnectionInitialData initialData) {
    // TODO: implement init
  }

  @override
  Future<void> sendMessage(MessagingConnectionSendData sendData) {
    // TODO: implement sendMessage
    throw UnimplementedError();
  }
}
