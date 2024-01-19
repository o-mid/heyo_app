enum MessageConnectionType { WIFI_DIRECT, RTC_DATA_CHANNEL }

enum MessageType {
  message,
  update,
  delete,
  confirm,
}

class WrappedMessageModel {
  factory WrappedMessageModel.fromJson(Map<String, dynamic> json) {
    return WrappedMessageModel(
      dataChannelMessagetype:
          MessageType.values.byName(json[dataChannelMessagetypeSerializedName] as String),
      chatName: json[chatNameSerializedName],
      remoteCoreIds: json[remoteCoreIdsSerializedName] as List<String>,
      chatId: json[chatIdSerializedName],
      message: json[messageSerializedName] as Map<String, dynamic>,
    );
  }
  static const dataChannelMessagetypeSerializedName = "dataChannelMessagetype";
  static const messageSerializedName = "message";
  static const chatNameSerializedName = "chatName";
  static const remoteCoreIdsSerializedName = "remoteCoreIds";
  static const chatIdSerializedName = "chatId";

  final MessageType dataChannelMessagetype;
  final String chatName;
  final List<String> remoteCoreIds;
  final String chatId;
  Map<String, dynamic> message;

  WrappedMessageModel({
    required this.dataChannelMessagetype,
    required this.chatName,
    required this.remoteCoreIds,
    required this.chatId,
    required this.message,
  });

  WrappedMessageModel copyWith({
    MessageType? dataChannelMessagetype,
    String? chatName,
    List<String>? remoteCoreIds,
    String? chatId,
    Map<String, dynamic>? message,
  }) {
    return WrappedMessageModel(
      dataChannelMessagetype: dataChannelMessagetype ?? this.dataChannelMessagetype,
      chatName: chatName ?? this.chatName,
      remoteCoreIds: remoteCoreIds ?? this.remoteCoreIds,
      chatId: chatId ?? this.chatId,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      dataChannelMessagetypeSerializedName: dataChannelMessagetype.name,
      chatNameSerializedName: chatName,
      remoteCoreIdsSerializedName: remoteCoreIds,
      chatIdSerializedName: chatId,
      messageSerializedName: message,
    };
  }
}
