import 'package:heyo/app/modules/messages/data/models/message_metadata.dart';

import 'reaction_model.dart';
import 'reply_to_model.dart';

enum CONTENT_TYPE {
  TEXT,
  IMAGE,
  VIDEO,
  AUDIO,
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
  final Metadata? metadata;
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
    this.metadata,
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
    Metadata? metadata,
    ReplyToModel? replyTo,
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
        metadata: metadata ?? this.metadata,
        replyTo: replyTo ?? this.replyTo,
        reactions: reactions ?? this.reactions,
        senderName: senderName ?? this.senderName,
        senderAvatar: senderAvatar ?? this.senderAvatar,
        isFromMe: isFromMe ?? this.isFromMe,
        isSelected: isSelected ?? this.isSelected,
      );
}
