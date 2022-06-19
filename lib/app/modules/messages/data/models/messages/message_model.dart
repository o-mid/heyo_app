import '../reaction_model.dart';
import '../reply_to_model.dart';

enum CONTENT_TYPE {
  TEXT,
  IMAGE,
  VIDEO,
  AUDIO,
  FILE,
  CALL,
  LOCATION,
  LIVE_LOCATION,
  MULTI_MEDIA;
}

enum MESSAGE_STATUS {
  SENDING,
  SENT,
  FAILED,
  READ,
}

abstract class MessageModel {
  final MESSAGE_STATUS status;
  final CONTENT_TYPE type;
  final String messageId;
  final DateTime timestamp;
  final ReplyToModel? replyTo;
  final Map<String, ReactionModel> reactions;
  final String senderName;
  final String senderAvatar;
  final bool isFromMe;
  final bool isForwarded;
  final bool isSelected;

  MessageModel({
    required this.messageId,
    required this.timestamp,
    required this.senderName,
    required this.senderAvatar,
    required this.type,
    this.status = MESSAGE_STATUS.SENDING,
    this.isFromMe = false,
    this.isSelected = false,
    this.isForwarded = false,
    this.replyTo,
    this.reactions = const {},
  });

  MessageModel copyWith({
    String? messageId,
    MESSAGE_STATUS? status,
    DateTime? timestamp,
    CONTENT_TYPE? type,
    Map<String, ReactionModel>? reactions,
    bool? isFromMe,
    bool? isForwarded,
    bool? isSelected,
    bool clearReply,
  });
}
