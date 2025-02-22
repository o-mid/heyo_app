import '../../../messages/connection/messaging_session.dart';
import '../../../messages/data/models/messages/message_model.dart';
import 'messaging_participant_model.dart';

class MessagesViewArgumentsModel {
  final List<MessageModel>? forwardedMessages;
  final MessageSession? session;
  final MessagingConnectionType connectionType;
  final String chatName;

  final List<MessagingParticipantModel> participants;
  MessagesViewArgumentsModel({
    required this.participants,
    this.forwardedMessages,
    this.session,
    this.chatName = '',
    this.connectionType = MessagingConnectionType.internet,
  });
}

enum MessagingConnectionType { wifiDirect, internet }
