class UserPreferences {
  static const scrollPositionSerializedName = "scrollPosition";
  static const chatIdSerializedName = 'chatId';
  final String chatId;
  final String scrollPosition;

  UserPreferences({
    required this.chatId,
    required this.scrollPosition,
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) => UserPreferences(
        scrollPosition: json[scrollPositionSerializedName],
        chatId: json[chatIdSerializedName],
      );

  Map<String, dynamic> toJson() => {
        scrollPositionSerializedName: scrollPosition,
        chatIdSerializedName: chatId,
      };

  UserPreferences copyWith({
    String? scrollPosition,
    String? chatId,
  }) {
    return UserPreferences(
      scrollPosition: scrollPosition ?? this.scrollPosition,
      chatId: chatId ?? this.chatId,
    );
  }
}
