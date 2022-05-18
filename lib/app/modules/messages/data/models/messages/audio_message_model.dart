import 'package:heyo/app/modules/messages/data/models/metadatas/audio_metadata.dart';

import 'message_model.dart';
import '../reaction_model.dart';

class AudioMessageModel extends MessageModel {
  final String url;
  final String? localUrl;
  final AudioMetadata metadata;
  AudioMessageModel({
    required this.url,
    this.localUrl,
    required this.metadata,
    required super.messageId,
    required super.timestamp,
    required super.senderName,
    required super.senderAvatar,
    super.status = MESSAGE_STATUS.SENDING,
    super.isFromMe = false,
    super.isForwarded = false,
    super.isSelected = false,
    super.replyTo,
    super.reactions = const <String, ReactionModel>{},
  });

  @override
  AudioMessageModel copyWith({
    String? localUrl,
    String? messageId,
    MESSAGE_STATUS? status,
    DateTime? timestamp,
    Map<String, ReactionModel>? reactions,
    bool? isFromMe,
    bool? isForwarded,
    bool? isSelected,
    bool clearReply = false,
  }) {
    return AudioMessageModel(
      url: url,
      localUrl: localUrl ?? this.localUrl,
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
