import 'package:heyo/app/modules/messages/data/models/metadatas/video_metadata.dart';

import 'message_model.dart';
import '../reaction_model.dart';

class VideoMessageModel extends MessageModel {
  final String url;
  final VideoMetadata metadata;

  VideoMessageModel({
    required this.url,
    required this.metadata,
    required super.messageId,
    required super.timestamp,
    required super.senderName,
    required super.senderAvatar,
    super.type = CONTENT_TYPE.VIDEO,
    super.status = MESSAGE_STATUS.SENDING,
    super.isFromMe = false,
    super.isForwarded = false,
    super.isSelected = false,
    super.replyTo,
    super.reactions = const <String, ReactionModel>{},
  });

  @override
  VideoMessageModel copyWith({
    String? messageId,
    MESSAGE_STATUS? status,
    bool? isLocal,
    DateTime? timestamp,
    CONTENT_TYPE? type,
    Map<String, ReactionModel>? reactions,
    bool? isFromMe,
    bool? isForwarded,
    bool? isSelected,
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
      isFromMe: isFromMe ?? this.isFromMe,
      isForwarded: isForwarded ?? this.isForwarded,
      isSelected: isSelected ?? this.isSelected,
      reactions: reactions ?? this.reactions,
      replyTo: clearReply ? null : replyTo,
      type: type ?? this.type,
    );
  }
}
