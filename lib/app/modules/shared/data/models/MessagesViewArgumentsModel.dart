import 'package:heyo/app/modules/chats/data/models/chat_model.dart';

import '../../../messages/data/models/messages/message_model.dart';

class MessagesViewArgumentsModel {
  final ChatModel chat;
  final List<MessageModel>? forwardedMessages;
  MessagesViewArgumentsModel({required this.chat, this.forwardedMessages});
}
