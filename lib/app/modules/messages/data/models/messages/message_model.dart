import "../reaction_model.dart";
import "../reply_to_model.dart";

enum MessageContentType {
  text,
  image,
  video,
  audio,
  file,
  call,
  location,
  liveLocation,
  multiMedia,
}

enum MessageStatus {
  sending,
  sent,
  delivered,
  read,
  failed,
}

abstract class MessageModel {
  static const statusSerializedName = "status";
  static const typeSerializedName = "type";
  static const messageIdSerializedName = "messageId";
  static const chatIdSerializedName = "chatId";
  static const timestampSerializedName = "timestamp";
  static const replyToSerializedName = "replyTo";
  static const reactionsSerializedName = "reactions";
  static const senderNameSerializedName = "senderName";
  static const senderAvatarSerializedName = "senderAvatar";
  static const isFromMeSerializedName = "isFromMe";
  static const isForwardedSerializedName = "isForwarded";

  final MessageStatus status;
  final MessageContentType type;
  final String messageId;
  final String chatId;
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
    required this.chatId,
    required this.timestamp,
    required this.senderName,
    required this.senderAvatar,
    required this.type,
    this.status = MessageStatus.sending,
    this.isFromMe = false,
    this.isSelected = false,
    this.isForwarded = false,
    this.replyTo,
    this.reactions = const {},
  });

  MessageModel copyWith({
    String? messageId,
    String? chatId,
    MessageStatus? status,
    DateTime? timestamp,
    MessageContentType? type,
    Map<String, ReactionModel>? reactions,
    bool? isFromMe,
    bool? isForwarded,
    bool? isSelected,
    bool clearReply,
  });

  Map<String, dynamic> toJson();
}
