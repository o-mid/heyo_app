import 'package:heyo/app/modules/messages/data/models/reaction_model.dart';

import 'message_model.dart';

class ImageMessageModel extends MessageModel {
  final String url;
  ImageMessageModel({
    required this.url,
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
  ImageMessageModel copyWith({
    String? url,
    MESSAGE_STATUS? status,
    DateTime? timestamp,
    Map<String, ReactionModel>? reactions,
    bool? isSelected,
  }) {
    return ImageMessageModel(
      url: url ?? this.url,
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
