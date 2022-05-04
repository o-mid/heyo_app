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
  AudioMessageModel copyWith({
    String? localUrl,
    MESSAGE_STATUS? status,
    DateTime? timestamp,
    Map<String, ReactionModel>? reactions,
    bool? isForwarded,
    bool? isSelected,
  }) {
    return AudioMessageModel(
      url: url,
      localUrl: localUrl ?? this.localUrl,
      metadata: metadata,
      messageId: messageId,
      timestamp: timestamp ?? this.timestamp,
      senderName: senderName,
      senderAvatar: senderAvatar,
      status: status ?? this.status,
      isFromMe: isFromMe,
      isForwarded: isForwarded ?? this.isForwarded,
      isSelected: isSelected ?? this.isSelected,
      reactions: reactions ?? this.reactions,
      replyTo: replyTo,
    );
  }
}
