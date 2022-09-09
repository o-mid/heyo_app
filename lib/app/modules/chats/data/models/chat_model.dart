class ChatModel {
  final String id;
  final String name;
  final String icon;
  final String lastMessage;
  final String timestamp;
  final bool isOnline;
  final bool isVerified;
  final int notificationCount;

  ChatModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.lastMessage,
    required this.timestamp,
    this.isOnline = false,
    this.isVerified = false,
    this.notificationCount = 0,
  });
}
