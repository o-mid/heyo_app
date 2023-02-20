class ConfirmMessageModel {
  static const messageIdSerializedName = 'messageId';
  static const statusSerializedName = 'status';

  String messageId;
  ConfirmMessageStatus status;

  ConfirmMessageModel({
    required this.messageId,
    required this.status,
  });

  ConfirmMessageModel copyWith({String? messageId, ConfirmMessageStatus? status}) {
    return ConfirmMessageModel(
      messageId: messageId ?? this.messageId,
      status: status ?? this.status,
    );
  }

  factory ConfirmMessageModel.fromJson(Map<String, dynamic> json) => ConfirmMessageModel(
        messageId: json[messageIdSerializedName],
        status: ConfirmMessageStatus.values.byName(json[statusSerializedName]),
      );

  Map<String, dynamic> toJson() => {
        messageIdSerializedName: messageId,
        statusSerializedName: status.name,
      };
}

enum ConfirmMessageStatus {
  delivered,
  read,
}
