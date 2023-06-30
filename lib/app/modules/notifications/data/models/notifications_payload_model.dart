class NotificationsPayloadModel {
  static const String chatIdSerializedName = "chatId";
  static const String messageIdSerializedName = "messageId";
  static const String senderNameSerializedName = "senderName";
  static const String replyMsgSerializedName = "replyMsg";

  final String chatId;
  final String messageId;
  final String senderName;
  final String replyMsg;

  NotificationsPayloadModel({
    required this.chatId,
    required this.messageId,
    this.senderName = "",
    this.replyMsg = "",
  });

  NotificationsPayloadModel copyWith({
    String? chatId,
    String? messageId,
    String? senderName,
    String? replyMsg,
  }) {
    return NotificationsPayloadModel(
      chatId: chatId ?? this.chatId,
      messageId: messageId ?? this.messageId,
      senderName: senderName ?? this.senderName,
      replyMsg: replyMsg ?? this.replyMsg,
    );
  }

  Map<String, String> toJson() => {
        chatIdSerializedName: chatId,
        messageIdSerializedName: messageId,
        senderNameSerializedName: senderName,
        replyMsgSerializedName: replyMsg,
      };

  factory NotificationsPayloadModel.fromJson(Map<String, dynamic> json) =>
      NotificationsPayloadModel(
        chatId: json[chatIdSerializedName],
        messageId: json[messageIdSerializedName],
        senderName: json[senderNameSerializedName],
        replyMsg: json[replyMsgSerializedName],
      );
}
