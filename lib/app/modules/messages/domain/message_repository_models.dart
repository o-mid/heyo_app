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
