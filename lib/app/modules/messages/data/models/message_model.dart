enum MESSAGE_TYPE {
  TEXT,
}

enum MESSAGE_STATUS {
  SENDING,
  SENT,
  FAILED,
  READ,
}

class MessageModel {
  final MESSAGE_TYPE type;
  final MESSAGE_STATUS status;
  final String payload;
  final DateTime timestamp;
  final ReplyToModel? replyTo;
  final String senderName;
  final String senderAvatar;
  final bool isFromMe;
  final bool isSelected;

  MessageModel({
    this.type = MESSAGE_TYPE.TEXT,
    this.status = MESSAGE_STATUS.SENDING,
    required this.payload,
    required this.timestamp,
    this.replyTo,
    required this.senderName,
    required this.senderAvatar,
    this.isFromMe = false,
    this.isSelected = false,
  });

  // Todo: use freezed package
  MessageModel copyWith({
    MESSAGE_TYPE? type,
    MESSAGE_STATUS? status,
    String? payload,
    DateTime? timestamp,
    String? senderName,
    String? senderAvatar,
    bool? isFromMe,
    bool? isSelected,
  }) =>
      MessageModel(
        type: type ?? this.type,
        status: status ?? this.status,
        payload: payload ?? this.payload,
        timestamp: timestamp ?? this.timestamp,
        senderName: senderName ?? this.senderName,
        senderAvatar: senderAvatar ?? this.senderAvatar,
        isFromMe: isFromMe ?? this.isFromMe,
        isSelected: isSelected ?? this.isSelected,
      );
}

class ReplyToModel {
  final String repliedToName;
  final String repliedToMessage;

  ReplyToModel({
    required this.repliedToName,
    required this.repliedToMessage,
  });
}
