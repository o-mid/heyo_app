class UserPreferences {
  static const scrollPositionSerializedName = "scrollPosition";
  static const chatIdSerializedName = 'chatId';
  static const lastReadMessageIdSerializedName = 'lastReadMessageId';
  final String chatId;
  final String scrollPosition;
  final String lastReadMessageId;

  UserPreferences({
    required this.chatId,
    required this.scrollPosition,
    required this.lastReadMessageId,
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) => UserPreferences(
        scrollPosition: json[scrollPositionSerializedName],
        chatId: json[chatIdSerializedName],
        lastReadMessageId: json[lastReadMessageIdSerializedName],
      );

  Map<String, dynamic> toJson() => {
        scrollPositionSerializedName: scrollPosition,
        chatIdSerializedName: chatId,
        lastReadMessageIdSerializedName: lastReadMessageId,
      };

  UserPreferences copyWith({
    String? scrollPosition,
    String? chatId,
    String? lastReadMessageId,
  }) {
    return UserPreferences(
      scrollPosition: scrollPosition ?? this.scrollPosition,
      chatId: chatId ?? this.chatId,
      lastReadMessageId: lastReadMessageId ?? this.lastReadMessageId,
    );
  }
}
