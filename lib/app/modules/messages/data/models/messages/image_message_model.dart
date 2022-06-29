import 'package:heyo/app/modules/messages/data/models/metadatas/image_metadata.dart';
import 'package:heyo/app/modules/messages/data/models/reaction_model.dart';

import 'message_model.dart';

class ImageMessageModel extends MessageModel {
  final String url;
  final ImageMetadata metadata;
  final bool isLocal;
  ImageMessageModel({
    required this.url,
    required this.isLocal,
    required this.metadata,
    required super.messageId,
    required super.timestamp,
    required super.senderName,
    required super.senderAvatar,
    super.status = MESSAGE_STATUS.SENDING,
    super.type = CONTENT_TYPE.IMAGE,
    super.isFromMe = false,
    super.isForwarded = false,
    super.isSelected = false,
    super.replyTo,
    super.reactions = const <String, ReactionModel>{},
  });

  @override
  ImageMessageModel copyWith({
    String? url,
    bool? isLocal,
    String? messageId,
    MESSAGE_STATUS? status,
    DateTime? timestamp,
    CONTENT_TYPE? type,
    Map<String, ReactionModel>? reactions,
    bool? isFromMe,
    bool? isForwarded,
    bool? isSelected,
    bool clearReply = false,
  }) {
    return ImageMessageModel(
      url: url ?? this.url,
      isLocal: isLocal ?? this.isLocal,
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
