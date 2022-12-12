import 'dart:convert';

import 'package:heyo/app/modules/messages/data/models/metadatas/video_metadata.dart';

import '../reply_to_model.dart';
import 'message_model.dart';
import '../reaction_model.dart';

class VideoMessageModel extends MessageModel {
  static const urlSerializedName = 'url';
  static const metadataSerializedName = 'metadata';

  final String url;
  final VideoMetadata metadata;

  VideoMessageModel({
    required this.url,
    required this.metadata,
    required super.messageId,
    required super.timestamp,
    required super.senderName,
    required super.senderAvatar,
    super.type = MessageContentType.video,
    super.status = MessageStatus.sending,
    super.isFromMe = false,
    super.isForwarded = false,
    super.isSelected = false,
    super.replyTo,
    super.reactions = const <String, ReactionModel>{},
  });

  @override
  VideoMessageModel copyWith({
    String? messageId,
    String? url,
    MessageStatus? status,
    bool? isLocal,
    DateTime? timestamp,
    MessageContentType? type,
    Map<String, ReactionModel>? reactions,
    bool? isFromMe,
    bool? isForwarded,
    bool? isSelected,
    bool clearReply = false,
  }) {
    return VideoMessageModel(
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
      type: type ?? this.type,
    );
  }

  factory VideoMessageModel.fromJson(Map<String, dynamic> json) => VideoMessageModel(
        url: json[urlSerializedName],
        metadata: VideoMetadata.fromJson(json[metadataSerializedName]),
        // parent props:
        messageId: json[MessageModel.messageIdSerializedName],
        timestamp: DateTime.parse(json[MessageModel.timestampSerializedName]),
        senderName: json[MessageModel.senderNameSerializedName],
        senderAvatar: json[MessageModel.senderAvatarSerializedName],
        status: MessageStatus.values.byName(json[MessageModel.statusSerializedName]),
        type: MessageContentType.values.byName(json[MessageModel.typeSerializedName]),
        isFromMe: json[MessageModel.isFromMeSerializedName],
        isForwarded: json[MessageModel.isForwardedSerializedName],
        reactions: (jsonDecode(json[MessageModel.reactionsSerializedName]) as Map<String, dynamic>)
            .map((String k, v) => MapEntry(k, ReactionModel.fromJson(v))),
        replyTo: json[MessageModel.replyToSerializedName] == null
            ? null
            : ReplyToModel.fromJson(json[MessageModel.replyToSerializedName]),
      );

  @override
  Map<String, dynamic> toJson() => {
        urlSerializedName: url,
        metadataSerializedName: metadata.toJson(),
        // parent props:
        MessageModel.messageIdSerializedName: messageId,
        MessageModel.timestampSerializedName: timestamp.toIso8601String(),
        MessageModel.senderNameSerializedName: senderName,
        MessageModel.senderAvatarSerializedName: senderAvatar,
        MessageModel.statusSerializedName: status.name,
        MessageModel.typeSerializedName: type.name,
        MessageModel.isFromMeSerializedName: isFromMe,
        MessageModel.isForwardedSerializedName: isForwarded,
        MessageModel.reactionsSerializedName: jsonEncode(reactions),
        MessageModel.replyToSerializedName: replyTo?.toJson(),
      };
}
