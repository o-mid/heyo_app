import 'package:heyo/app/modules/messages/data/models/reply_to_model.dart';

class UserInstance {
  String coreId;
  String? iconUrl;
  UserInstance({required this.coreId, this.iconUrl});
}

class UserStates {
  String lastReadRemoteMessagesId;
  String scrollPositionMessagesId;
  String chatId;

  DateTime lastMessageTimestamp;
  String lastMessagePreview;
  UserStates(
      {required this.lastReadRemoteMessagesId,
      required this.scrollPositionMessagesId,
      required this.chatId,
      required this.lastMessagePreview,
      required this.lastMessageTimestamp});
}

class SendMessageRepoModel {
  final String newMessageValue;
  final ReplyToModel? replyingToValue;
  final String chatId;
  final String remoteCoreId;

  SendMessageRepoModel({
    required this.newMessageValue,
    required this.chatId,
    required this.remoteCoreId,
    this.replyingToValue,
  });
}
