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
          isSelected: isSelected,
          reactions: reactions,
          replyTo: replyTo,
        );

  @override
  TextMessageModel copyWith({
    String? text,
    MESSAGE_STATUS? status,
    DateTime? timestamp,
    Map<String, ReactionModel>? reactions,
    bool? isSelected,
  }) {
    return TextMessageModel(
      text: text ?? this.text,
      messageId: messageId,
      timestamp: timestamp ?? this.timestamp,
      senderName: senderName,
      senderAvatar: senderAvatar,
      status: status ?? this.status,
      isFromMe: isFromMe,
      isSelected: isSelected ?? this.isSelected,
      reactions: reactions ?? this.reactions,
      replyTo: replyTo,
    );
  }
}
