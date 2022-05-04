import 'package:heyo/app/modules/messages/data/models/reaction_model.dart';

import 'message_model.dart';

class TextMessageModel extends MessageModel {
  final String text;
  TextMessageModel({
    required this.text,
    required String messageId,
    required DateTime timestamp,
    required String senderName,
    required String senderAvatar,
    status = MESSAGE_STATUS.SENDING,
    isFromMe = false,
    isForwarded = false,
    isSelected = false,
    replyTo,
    reactions = const <String, ReactionModel>{},
  }) : super(
          messageId: messageId,
          timestamp: timestamp,
          senderName: senderName,
          senderAvatar: senderAvatar,
          status: status,
          isFromMe: isFromMe,
          isForwarded: isForwarded,
          isSelected: isSelected,
          reactions: reactions,
          replyTo: replyTo,
        );

  @override
  TextMessageModel copyWith({
    String? text,
    String? messageId,
    MESSAGE_STATUS? status,
    DateTime? timestamp,
    Map<String, ReactionModel>? reactions,
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
      isFromMe: isFromMe,
      isForwarded: isForwarded ?? this.isForwarded,
      isSelected: isSelected ?? this.isSelected,
      reactions: reactions ?? this.reactions,
      replyTo: clearReply ? null : replyTo,
    );
  }
}
