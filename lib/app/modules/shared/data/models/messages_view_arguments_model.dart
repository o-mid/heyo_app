import '../../../messages/connection/messaging_session.dart';
import '../../../messages/data/models/messages/message_model.dart';

class MessagesViewArgumentsModel {
  final List<MessageModel>? forwardedMessages;
  final MessageSession? session;
  final MessagingConnectionType connectionType;
  final String coreId;
  final String? iconUrl;
  MessagesViewArgumentsModel({
    required this.coreId,
    this.forwardedMessages,
    this.session,
    this.iconUrl,
    this.connectionType = MessagingConnectionType.internet,
  });
}

enum MessagingConnectionType { wifiDirect, internet }
