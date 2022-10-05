class ChatModel {
  static const idSerializedName = 'id';
  static const nameSerializedName = 'name';
  static const iconSerializedName = 'icon';
  static const lastMessageSerializedName = 'lastMessage';
  static const timestampSerializedName = 'timestamp';
  static const isOnlineSerializedName = 'isOnline';
  static const isVerifiedSerializedName = 'isVerified';
  static const notificationCountSerializedName = 'notificationCount';

  final String id;
  final String name;
  final String icon;
  final String lastMessage;
  final DateTime timestamp;
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

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        id: json[idSerializedName],
        name: json[nameSerializedName],
        icon: json[iconSerializedName],
        lastMessage: json[lastMessageSerializedName],
        timestamp: DateTime.parse(json[timestampSerializedName]),
        isOnline: json[isOnlineSerializedName],
        isVerified: json[isVerifiedSerializedName],
        notificationCount: json[notificationCountSerializedName],
      );

  Map<String, dynamic> toJson() => {
        idSerializedName: id,
        nameSerializedName: name,
        iconSerializedName: icon,
        lastMessageSerializedName: lastMessage,
        timestampSerializedName: timestamp.toIso8601String(),
        isOnlineSerializedName: isOnline,
        isVerifiedSerializedName: isVerified,
        notificationCountSerializedName: notificationCount,
      };

  ChatModel copyWith({
    String? id,
    String? name,
    String? icon,
    String? lastMessage,
    DateTime? timestamp,
    bool? isOnline,
    bool? isVerified,
    int? notificationCount,
  }) {
    return ChatModel(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      lastMessage: lastMessage ?? this.lastMessage,
      timestamp: timestamp ?? this.timestamp,
      isOnline: isOnline ?? this.isOnline,
      isVerified: isVerified ?? this.isVerified,
      notificationCount: notificationCount ?? this.notificationCount,
    );
  }
}
