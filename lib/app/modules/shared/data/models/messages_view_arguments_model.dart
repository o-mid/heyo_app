import 'package:heyo/app/modules/chats/data/models/chat_model.dart';
import 'package:heyo/app/modules/messaging/messaging_session.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model.dart';

import '../../../messages/data/models/messages/message_model.dart';

class MessagesViewArgumentsModel {
  final ChatModel chat;
  final UserModel user;
  final List<MessageModel>? forwardedMessages;
  final MessageSession? session;
  MessagesViewArgumentsModel({
    required this.chat,
    required this.user,
    this.forwardedMessages,
    this.session,
  });
}
