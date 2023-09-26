class DeleteMessageModel {
  static const messageIdsSerializedName = 'messageIds';
  List<String> messageIds;
  DeleteMessageModel({
    required this.messageIds,
  });

  DeleteMessageModel copyWith({List<String>? messageIds}) {
    return DeleteMessageModel(
      messageIds: messageIds ?? this.messageIds,
    );
  }

  factory DeleteMessageModel.fromJson(Map<String, dynamic> json) => DeleteMessageModel(
        messageIds:
            List<String>.from((json[messageIdsSerializedName] as List<String>).map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        messageIdsSerializedName: messageIds,
      };
}
