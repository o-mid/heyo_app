import 'package:heyo/app/modules/chats/data/models/chat_model.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model.dart';
import 'package:heyo/app/modules/messaging/messaging_session.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model/user_model.dart';

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
