import 'dart:convert';

import 'package:heyo/app/modules/messages/data/models/messages/image_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/message_model.dart';
import 'package:heyo/app/modules/messages/data/models/reaction_model.dart';
import 'package:heyo/app/modules/messages/utils/message_from_json.dart';

import '../reply_to_model.dart';

class MultiMediaMessageModel extends MessageModel {
  static const mediaListSerializedName = 'mediaList';

  final List<dynamic> mediaList;

  MultiMediaMessageModel({
    required this.mediaList,
    required super.messageId,
    required super.chatId,
    required super.timestamp,
    required super.isFromMe,
    required super.senderName,
    required super.senderAvatar,
    super.isForwarded,
    super.isSelected,
    bool clearReply = false,
    super.status = MessageStatus.sending,
    super.type = MessageContentType.multiMedia,
    super.replyTo,
    super.reactions = const <String, ReactionModel>{},
  });

  @override
  MultiMediaMessageModel copyWith({
    List<ImageMessageModel>? mediaList,
    String? messageId,
    String? chatId,
    MessageStatus? status,
    MessageContentType? type,
    DateTime? timestamp,
    Map<String, ReactionModel>? reactions,
    bool clearReply = false,
    bool? isFromMe,
    bool? isForwarded,
    bool? isSelected,
    String? senderName,
    String? senderAvatar,
  }) {
    return MultiMediaMessageModel(
      mediaList: mediaList ?? this.mediaList,
      messageId: messageId ?? this.messageId,
      chatId: chatId ?? this.chatId,
      timestamp: timestamp ?? this.timestamp,
      senderName: senderName ?? this.senderName,
      senderAvatar: senderAvatar ?? this.senderAvatar,
      reactions: reactions ?? this.reactions,
      status: status ?? this.status,
      replyTo: clearReply ? null : replyTo,
      isFromMe: isFromMe ?? this.isFromMe,
      isForwarded: isForwarded ?? this.isForwarded,
      type: type ?? this.type,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  factory MultiMediaMessageModel.fromJson(Map<String, dynamic> json) => MultiMediaMessageModel(
        mediaList: List<dynamic>.from(
          (json[mediaListSerializedName] as List<dynamic>)
              .map((x) => messageFromJson(x as Map<String, dynamic>)),
        ),
        // parent props:
        messageId: json[MessageModel.messageIdSerializedName],
        chatId: json[MessageModel.chatIdSerializedName],
        timestamp: DateTime.parse(json[MessageModel.timestampSerializedName]),
        senderName: json[MessageModel.senderNameSerializedName],
        senderAvatar: json[MessageModel.senderAvatarSerializedName],
        status: MessageStatus.values.byName(json[MessageModel.statusSerializedName]),
        type: MessageContentType.values.byName(json[MessageModel.typeSerializedName]),
        isFromMe: json[MessageModel.isFromMeSerializedName] as bool,
        isForwarded: json[MessageModel.isForwardedSerializedName] as bool,
        reactions: (jsonDecode(json[MessageModel.reactionsSerializedName]) as Map<String, dynamic>)
            .map((String k, v) => MapEntry(k, ReactionModel.fromJson(v as Map<String, dynamic>))),
        replyTo: json[MessageModel.replyToSerializedName] == null
            ? null
            : ReplyToModel.fromJson(
                json[MessageModel.replyToSerializedName] as Map<String, dynamic>,
              ),
      );

  @override
  Map<String, dynamic> toJson() => {
        mediaListSerializedName: List<dynamic>.from(mediaList.map((x) => x.toJson())),
        // parent props:
        MessageModel.messageIdSerializedName: messageId,
        MessageModel.chatIdSerializedName: chatId,
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
