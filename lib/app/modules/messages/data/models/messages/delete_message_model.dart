class DeleteMessageModel {
  DeleteMessageModel({
    required this.messageIds,
  });

  factory DeleteMessageModel.fromJson(Map<String, dynamic> json) {
    var rawList = json[messageIdsSerializedName] as List<dynamic>;

    var messageIds = <String>[];

    for (final item in rawList) {
      if (item is String) {
        messageIds.add(item);
      } else {
        throw FormatException('Expected a String but got ${item.runtimeType}');
      }
    }

    return DeleteMessageModel(messageIds: messageIds);
  }
  static const messageIdsSerializedName = 'messageIds';
  List<String> messageIds;

  DeleteMessageModel copyWith({List<String>? messageIds}) {
    return DeleteMessageModel(
      messageIds: messageIds ?? this.messageIds,
    );
  }

  Map<String, dynamic> toJson() => {
        messageIdsSerializedName: messageIds,
      };
}
