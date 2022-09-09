class ReplyToModel {
  static const repliedToMessageIdSerializedName = 'repliedToMessageId';
  static const repliedToNameSerializedName = 'repliedToName';
  static const repliedToMessageSerializedName = 'repliedToMessage';

  final String repliedToMessageId;
  final String repliedToName;
  final String repliedToMessage;

  ReplyToModel({
    required this.repliedToMessageId,
    required this.repliedToName,
    required this.repliedToMessage,
  });

  factory ReplyToModel.fromJson(Map<String, dynamic> json) => ReplyToModel(
        repliedToMessageId: json[repliedToMessageIdSerializedName],
        repliedToName: json[repliedToNameSerializedName],
        repliedToMessage: json[repliedToMessageSerializedName],
      );

  Map<String, dynamic> toJson() => {
        repliedToMessageIdSerializedName: repliedToMessageId,
        repliedToNameSerializedName: repliedToName,
        repliedToMessageSerializedName: repliedToMessage,
      };
}
