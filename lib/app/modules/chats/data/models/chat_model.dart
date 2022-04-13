class ChatModel {
  String name;
  String icon;
  String lastMessage;
  String timestamp;
  bool isOnline;
  bool isVerified;
  int notificationCount;

  ChatModel({
    required this.name,
    required this.icon,
    required this.lastMessage,
    required this.timestamp,
    this.isOnline = false,
    this.isVerified = false,
    this.notificationCount = 0,
  });
}
