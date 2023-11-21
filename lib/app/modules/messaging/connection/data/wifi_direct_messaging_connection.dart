import 'package:heyo/app/modules/messaging/connection/domain/messaging_connection.dart';
import 'package:heyo/app/modules/messaging/connection/domain/messaging_connections_models.dart';


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