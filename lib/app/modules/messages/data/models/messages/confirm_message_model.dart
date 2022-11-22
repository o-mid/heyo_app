class ConfirmMessageModel {
  static const messageIdSerializedName = 'messageId';
  String messageId;
  ConfirmMessageModel({
    required this.messageId,
  });

  ConfirmMessageModel copyWith({String? messageId}) {
    return ConfirmMessageModel(
      messageId: messageId ?? this.messageId,
    );
  }

  factory ConfirmMessageModel.fromJson(Map<String, dynamic> json) => ConfirmMessageModel(
        messageId: json[messageIdSerializedName],
      );

  Map<String, dynamic> toJson() => {
        messageIdSerializedName: messageId,
      };
}
