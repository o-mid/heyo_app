import 'dart:convert';

import 'package:heyo/app/modules/messages/data/models/metadatas/audio_metadata.dart';
import 'package:heyo/app/modules/messages/data/models/reply_to_model.dart';

import 'message_model.dart';
import '../reaction_model.dart';

class AudioMessageModel extends MessageModel {
  static const urlSerializedName = 'url';
  static const localUrlSerializedName = 'localUrl';
  static const metadataSerializedName = 'metadata';

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
    super.status = MessageStatus.sending,
    super.type = MessageContentType.audio,
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
    MessageStatus? status,
    MessageContentType? type,
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
      // parent props:
      messageId: messageId ?? this.messageId,
      timestamp: timestamp ?? this.timestamp,
      senderName: senderName,
      senderAvatar: senderAvatar,
      status: status ?? this.status,
      type: type ?? this.type,
      isFromMe: isFromMe ?? this.isFromMe,
      isForwarded: isForwarded ?? this.isForwarded,
      isSelected: isSelected ?? this.isSelected,
      reactions: reactions ?? this.reactions,
      replyTo: clearReply ? null : replyTo,
    );
  }

  factory AudioMessageModel.fromJson(Map<String, dynamic> json) => AudioMessageModel(
        url: json[urlSerializedName],
        localUrl: json[localUrlSerializedName],
        metadata: AudioMetadata.fromJson(json[metadataSerializedName]),
        // parent props
        messageId: json[MessageModel.messageIdSerializedName],
        timestamp: DateTime.parse(json[MessageModel.timestampSerializedName]),
        senderName: json[MessageModel.senderNameSerializedName],
        senderAvatar: json[MessageModel.senderAvatarSerializedName],
        status: MessageStatus.values.byName(json[MessageModel.statusSerializedName]),
        type: MessageContentType.values.byName(json[MessageModel.typeSerializedName]),
        isFromMe: json[MessageModel.isFromMeSerializedName],
        isForwarded: json[MessageModel.isForwardedSerializedName],
        reactions: jsonDecode(json[MessageModel.reactionsSerializedName]),
        replyTo: json[MessageModel.replyToSerializedName] == null
            ? null
            : ReplyToModel.fromJson(json[MessageModel.replyToSerializedName]),
      );

  @override
  Map<String, dynamic> toJson() => {
        urlSerializedName: url,
        localUrlSerializedName: localUrl,
        metadataSerializedName: metadata.toJson(),
        // parent props
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
