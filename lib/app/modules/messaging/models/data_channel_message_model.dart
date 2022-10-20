enum DataChannelMessageType {
  message,
  update,
  delete,
  confirm,
}

class DataChannelMessageModel {
  static const dataChannelMessagetypeSerializedName = "dataChannelMessagetype";
  static const messageSerializedName = "message";

  final DataChannelMessageType dataChannelMessagetype;
  Map<String, dynamic> message;

  DataChannelMessageModel({
    required this.dataChannelMessagetype,
    required this.message,
  });

  DataChannelMessageModel copyWith({
    final DataChannelMessageType? dataChannelMessagetype,
    Map<String, dynamic>? message,
  }) {
    return DataChannelMessageModel(
      dataChannelMessagetype: dataChannelMessagetype ?? this.dataChannelMessagetype,
      message: message ?? this.message,
    );
  }

  factory DataChannelMessageModel.fromJson(Map<String, dynamic> json) => DataChannelMessageModel(
        dataChannelMessagetype:
            DataChannelMessageType.values.byName(json[dataChannelMessagetypeSerializedName]),
        message: json[messageSerializedName] as Map<String, dynamic>,
      );

  Map<String, dynamic> toJson() => {
        dataChannelMessagetypeSerializedName: dataChannelMessagetype.name,
        messageSerializedName: message,
      };
}
