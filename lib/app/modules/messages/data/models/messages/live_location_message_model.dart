import 'dart:convert';

import 'package:heyo/app/modules/messages/data/models/messages/message_model.dart';
import 'package:heyo/app/modules/messages/data/models/reaction_model.dart';

import '../reply_to_model.dart';

class LiveLocationMessageModel extends MessageModel {
  static const latitudeSerializedName = 'latitude';
  static const longitudeSerializedName = 'longitude';
  static const endTimeSerializedName = 'endTime';

  final double latitude;
  final double longitude;
  final DateTime endTime;

  LiveLocationMessageModel({
    required this.latitude,
    required this.longitude,
    required this.endTime,
    required super.messageId,
    required super.chatId,
    required super.timestamp,
    required super.senderName,
    required super.senderAvatar,
    super.status = MessageStatus.sending,
    super.type = MessageContentType.liveLocation,
    super.isFromMe = false,
    super.isForwarded = false,
    super.isSelected = false,
    super.replyTo,
    super.reactions = const <String, ReactionModel>{},
  });

  @override
  MessageModel copyWith({
    DateTime? endTime,
    String? messageId,
    String? chatId,
    MessageStatus? status,
    MessageContentType? type,
    DateTime? timestamp,
    Map<String, ReactionModel>? reactions,
    bool? isFromMe,
    bool? isForwarded,
    bool? isSelected,
    String? senderAvatar,
    bool clearReply = false,
    String? senderName,
  }) {
    return LiveLocationMessageModel(
      latitude: latitude,
      longitude: longitude,
      endTime: endTime ?? this.endTime,
      messageId: messageId ?? this.messageId,
      chatId: chatId ?? this.chatId,
      timestamp: timestamp ?? this.timestamp,
      senderName: senderName ?? this.senderName,
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

  factory LiveLocationMessageModel.fromJson(Map<String, dynamic> json) => LiveLocationMessageModel(
        latitude: json[latitudeSerializedName] as double,
        longitude: json[longitudeSerializedName] as double,
        endTime: DateTime.parse(json[endTimeSerializedName]),
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
        latitudeSerializedName: latitude,
        longitudeSerializedName: longitude,
        endTimeSerializedName: endTime.toIso8601String(),
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
