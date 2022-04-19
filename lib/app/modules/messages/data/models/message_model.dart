enum CONTENT_TYPE {
  TEXT,
  IMAGE,
}

enum MESSAGE_STATUS {
  SENDING,
  SENT,
  FAILED,
  READ,
}

class MessageModel {
  final CONTENT_TYPE type;
  final MESSAGE_STATUS status;
  final String messageId;
  final String payload;
  final DateTime timestamp;
  final ReplyToModel? replyTo;
  final Map<String, ReactionModel> reactions;
  final String senderName;
  final String senderAvatar;
  final bool isFromMe;
  final bool isSelected;

  MessageModel({
    this.type = CONTENT_TYPE.TEXT,
    this.status = MESSAGE_STATUS.SENDING,
    required this.messageId,
    required this.payload,
    required this.timestamp,
    this.replyTo,
    this.reactions = const {},
    required this.senderName,
    required this.senderAvatar,
    this.isFromMe = false,
    this.isSelected = false,
  });

  // Todo: use freezed package
  MessageModel copyWith({
    CONTENT_TYPE? type,
    MESSAGE_STATUS? status,
    String? messageId,
    String? payload,
    DateTime? timestamp,
    Map<String, ReactionModel>? reactions,
    String? senderName,
    String? senderAvatar,
    bool? isFromMe,
    bool? isSelected,
  }) =>
      MessageModel(
        type: type ?? this.type,
        status: status ?? this.status,
        payload: payload ?? this.payload,
        messageId: messageId ?? this.messageId,
        timestamp: timestamp ?? this.timestamp,
        reactions: reactions ?? this.reactions,
        senderName: senderName ?? this.senderName,
        senderAvatar: senderAvatar ?? this.senderAvatar,
        isFromMe: isFromMe ?? this.isFromMe,
        isSelected: isSelected ?? this.isSelected,
      );
}

class ReplyToModel {
  final String repliedToMessageId;
  final String repliedToName;
  final String repliedToMessage;

  ReplyToModel({
    required this.repliedToMessageId,
    required this.repliedToName,
    required this.repliedToMessage,
  });
}

class ReactionModel {
  /// List of user ids that have reacted
  final List<String> users;
  final bool isReactedByMe;

  ReactionModel({this.users = const [], this.isReactedByMe = false});

  ReactionModel copyWith({
    List<String>? users,
    bool? isReactedByMe,
  }) =>
      ReactionModel(
        users: users ?? this.users,
        isReactedByMe: isReactedByMe ?? this.isReactedByMe,
      );
}
