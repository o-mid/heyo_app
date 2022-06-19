import 'package:heyo/app/modules/messages/data/models/reaction_model.dart';

import 'message_model.dart';

class TextMessageModel extends MessageModel {
  final String text;
  TextMessageModel({
    required this.text,
    required super.messageId,
    required super.timestamp,
    required super.senderName,
    required super.senderAvatar,
    super.status = MESSAGE_STATUS.SENDING,
    super.isFromMe = false,
    super.isForwarded = false,
    super.type = CONTENT_TYPE.TEXT,
    super.isSelected = false,
    super.replyTo,
    super.reactions = const <String, ReactionModel>{},
  });

  @override
  TextMessageModel copyWith({
    String? text,
    String? messageId,
    MESSAGE_STATUS? status,
    CONTENT_TYPE? type,
    DateTime? timestamp,
    Map<String, ReactionModel>? reactions,
    bool? isFromMe,
    bool? isForwarded,
    bool? isSelected,
    bool clearReply = false,
  }) {
    return TextMessageModel(
      text: text ?? this.text,
      messageId: messageId ?? this.messageId,
      timestamp: timestamp ?? this.timestamp,
      senderName: senderName,
      senderAvatar: senderAvatar,
      status: status ?? this.status,
      isFromMe: isFromMe ?? this.isFromMe,
      isForwarded: isForwarded ?? this.isForwarded,
      isSelected: isSelected ?? this.isSelected,
      reactions: reactions ?? this.reactions,
      replyTo: clearReply ? null : replyTo,
      type: type ?? this.type,
    );
  }
}
