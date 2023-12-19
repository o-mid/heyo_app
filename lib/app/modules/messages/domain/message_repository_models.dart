import 'package:heyo/app/modules/messages/data/models/messages/message_model.dart';
import 'package:heyo/app/modules/messages/data/models/reply_to_model.dart';

import '../data/models/metadatas/file_metadata.dart';

class UserInstance {
  UserInstance({
    required this.coreId,
  });
  String coreId;
}

class UserStates {
  UserStates(
      {required this.lastReadRemoteMessagesId,
      required this.scrollPositionMessagesId,
      required this.chatId,
      required this.lastMessagePreview,
      required this.lastMessageTimestamp});
  String lastReadRemoteMessagesId;
  String scrollPositionMessagesId;
  String chatId;

  DateTime lastMessageTimestamp;
  String lastMessagePreview;
}
