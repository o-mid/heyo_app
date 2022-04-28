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
  VideoMessageModel copyWith({
    MESSAGE_STATUS? status,
    DateTime? timestamp,
    Map<String, ReactionModel>? reactions,
    bool? isSelected,
  }) {
    return VideoMessageModel(
      url: url,
      metadata: metadata,
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
