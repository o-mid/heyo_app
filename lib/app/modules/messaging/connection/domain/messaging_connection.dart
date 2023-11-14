import 'package:heyo/app/modules/messaging/connection/domain/messaging_connections_models.dart';

abstract class MessagingConnection {
  void init(MessagingConnectionInitialData initialData);

  Future<void> sendMessage(MessagingConnectionSendData sendData);

  Stream<MessagingConnectionReceivedData> getMessageStream();

  Stream<MessagingConnectionStatus> getConnectionStatus();
}
