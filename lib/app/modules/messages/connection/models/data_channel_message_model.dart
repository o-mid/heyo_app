enum MessageConnectionType { WIFI_DIRECT, RTC_DATA_CHANNEL }


enum MessageType {
  message,
  update,
  delete,
  confirm,
}

class WrappedMessageModel {
  static const dataChannelMessagetypeSerializedName = "dataChannelMessagetype";
  static const messageSerializedName = "message";

  final MessageType dataChannelMessagetype;
  Map<String, dynamic> message;

  WrappedMessageModel({
    required this.dataChannelMessagetype,
    required this.message,
  });

  WrappedMessageModel copyWith({
    final MessageType? dataChannelMessagetype,
    Map<String, dynamic>? message,
  }) {
    return WrappedMessageModel(
      dataChannelMessagetype:
          dataChannelMessagetype ?? this.dataChannelMessagetype,
      message: message ?? this.message,
    );
  }

  factory WrappedMessageModel.fromJson(Map<String, dynamic> json) =>
      WrappedMessageModel(
        dataChannelMessagetype: MessageType.values
            .byName(json[dataChannelMessagetypeSerializedName] as String),
        message: json[messageSerializedName] as Map<String, dynamic>,
      );

  Map<String, dynamic> toJson() => {
        dataChannelMessagetypeSerializedName: dataChannelMessagetype.name,
        messageSerializedName: message,
      };
}
