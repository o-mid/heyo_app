import 'dart:convert';
import 'dart:typed_data';

import 'package:heyo/app/modules/messages/data/models/metadatas/image_metadata.dart';
import 'package:heyo/app/modules/messages/data/models/reaction_model.dart';

import '../reply_to_model.dart';
import 'message_model.dart';

class ImageMessageModel extends MessageModel {
  static const urlSerializedName = 'url';
  static const metadataSerializedName = 'metadata';
  static const isLocalSerializedName = 'isLocal';
  static const intlistSerializedName = 'intlist';
  final String url;
  final ImageMetadata metadata;
  final bool isLocal;

  final List<int> intlist;

  ImageMessageModel({
    required this.url,
    required this.isLocal,
    required this.metadata,
    required super.messageId,
    required super.timestamp,
    required super.senderName,
    required super.senderAvatar,
    super.status = MessageStatus.sending,
    super.type = MessageContentType.image,
    required this.intlist,
    super.isFromMe = false,
    super.isForwarded = false,
    super.isSelected = false,
    super.replyTo,
    super.reactions = const <String, ReactionModel>{},
  });

  @override
  ImageMessageModel copyWith(
      {String? url,
      bool? isLocal,
      String? messageId,
      MessageStatus? status,
      DateTime? timestamp,
      MessageContentType? type,
      Map<String, ReactionModel>? reactions,
      bool? isFromMe,
      bool? isForwarded,
      bool? isSelected,
      bool clearReply = false,
      List<int>? intlist}) {
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
      intlist: intlist ?? this.intlist,
    );
  }

  factory ImageMessageModel.fromJson(Map<String, dynamic> json) => ImageMessageModel(
      url: json[urlSerializedName],
      metadata: ImageMetadata.fromJson(json[metadataSerializedName]),
      isLocal: json[isLocalSerializedName],
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
      intlist: jsonDecode(json[intlistSerializedName]).cast<int>());

  @override
  Map<String, dynamic> toJson() => {
        urlSerializedName: url,
        metadataSerializedName: metadata.toJson(),
        isLocalSerializedName: isLocal,
        intlistSerializedName: jsonEncode(intlist),
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
