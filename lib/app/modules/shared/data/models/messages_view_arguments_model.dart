import 'package:heyo/app/modules/chats/data/models/chat_model.dart';
import 'package:heyo/app/modules/messaging/messaging_session.dart';

import '../../../messages/data/models/messages/message_model.dart';

class MessagesViewArgumentsModel {
  final ChatModel chat;
  final List<MessageModel>? forwardedMessages;
  final MessageSession? session;
  MessagesViewArgumentsModel({
    required this.chat,
    this.forwardedMessages,
    this.session,
  });
}
