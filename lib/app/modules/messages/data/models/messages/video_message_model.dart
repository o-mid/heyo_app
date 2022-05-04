import 'package:heyo/app/modules/messages/data/models/metadatas/video_metadata.dart';

import 'message_model.dart';
import '../reaction_model.dart';

class VideoMessageModel extends MessageModel {
  final String url;
  final VideoMetadata metadata;
  VideoMessageModel({
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
  VideoMessageModel copyWith({
    String? messageId,
    MESSAGE_STATUS? status,
    DateTime? timestamp,
    Map<String, ReactionModel>? reactions,
    bool? isSelected,
    bool? isForwarded,
    bool clearReply = false,
  }) {
    return VideoMessageModel(
      url: url,
      metadata: metadata,
      messageId: messageId ?? this.messageId,
      timestamp: timestamp ?? this.timestamp,
      senderName: senderName,
      senderAvatar: senderAvatar,
      status: status ?? this.status,
      isFromMe: isFromMe,
      isSelected: isSelected ?? this.isSelected,
      isForwarded: isForwarded ?? this.isForwarded,
      reactions: reactions ?? this.reactions,

      replyTo: clearReply ? null : replyTo,
    );
  }
}
