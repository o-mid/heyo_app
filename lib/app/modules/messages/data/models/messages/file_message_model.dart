import 'dart:convert';

import 'package:heyo/app/modules/messages/data/models/metadatas/file_metadata.dart';

import '../reply_to_model.dart';
import 'message_model.dart';
import '../reaction_model.dart';

class FileMessageModel extends MessageModel {
  static const metadataSerializedName = 'metadata';

  final FileMetaData metadata;

  FileMessageModel({
    required this.metadata,
    required super.messageId,
    required super.chatId,
    required super.timestamp,
    required super.senderName,
    required super.senderAvatar,
    super.type = MessageContentType.file,
    super.status = MessageStatus.sending,
    super.isFromMe = false,
    super.isForwarded = false,
    super.isSelected = false,
    super.replyTo,
    super.reactions = const <String, ReactionModel>{},
  });

  @override
  FileMessageModel copyWith({
    String? messageId,
    String? chatId,
    MessageStatus? status,
    FileMetaData? metadata,
    bool? isLocal,
    MessageContentType? type,
    DateTime? timestamp,
    Map<String, ReactionModel>? reactions,
    bool? isFromMe,
    bool? isForwarded,
    String? senderAvatar,
    bool? isSelected,
    bool clearReply = false,
  }) {
    return FileMessageModel(
      metadata: metadata ?? this.metadata,
      messageId: messageId ?? this.messageId,
      chatId: chatId ?? this.chatId,
      timestamp: timestamp ?? this.timestamp,
      senderName: senderName,
      senderAvatar: senderAvatar ?? this.senderAvatar,
      status: status ?? this.status,
      isFromMe: isFromMe ?? this.isFromMe,
      isForwarded: isForwarded ?? this.isForwarded,
      isSelected: isSelected ?? this.isSelected,
      reactions: reactions ?? this.reactions,
      replyTo: clearReply ? null : replyTo,
      type: type ?? this.type,
    );
  }

  factory FileMessageModel.fromJson(Map<String, dynamic> json) => FileMessageModel(
        metadata: FileMetaData.fromJson(json[metadataSerializedName] as Map<String, dynamic>),
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
                json[MessageModel.replyToSerializedName] as Map<String, dynamic>),
      );

  @override
  Map<String, dynamic> toJson() => {
        metadataSerializedName: metadata.toJson(),
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
