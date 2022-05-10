import 'package:heyo/app/modules/messages/data/models/metadatas/image_metadata.dart';
import 'package:heyo/app/modules/messages/data/models/reaction_model.dart';

import 'message_model.dart';

class ImageMessageModel extends MessageModel {
  final String url;
  final ImageMetadata metadata;
  ImageMessageModel({
    required this.url,
    required this.metadata,
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
  ImageMessageModel copyWith({
    String? url,
    String? messageId,
    MESSAGE_STATUS? status,
    DateTime? timestamp,
    Map<String, ReactionModel>? reactions,
    bool? isFromMe,
    bool? isForwarded,
    bool? isSelected,
    bool clearReply = false,
  }) {
    return ImageMessageModel(
      url: url ?? this.url,
      metadata: metadata,
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
    );
  }
}
