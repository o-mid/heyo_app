import 'dart:convert';

import 'package:heyo/app/modules/messages/data/models/messages/message_model.dart';
import 'package:heyo/app/modules/messages/data/models/reaction_model.dart';

import '../reply_to_model.dart';

class LocationMessageModel extends MessageModel {
  static const latitudeSerializedName = 'latitude';
  static const longitudeSerializedName = 'longitude';
  static const addressSerializedName = 'address';

  final double latitude;
  final double longitude;
  final String address;

  LocationMessageModel({
    required this.latitude,
    required this.longitude,
    required this.address,
    required super.messageId,
    required super.timestamp,
    required super.senderName,
    required super.senderAvatar,
    super.status = MessageStatus.sending,
    super.type = MessageContentType.location,
    super.isFromMe = false,
    super.isForwarded = false,
    super.isSelected = false,
    super.replyTo,
    super.reactions = const <String, ReactionModel>{},
  });

  @override
  MessageModel copyWith({
    String? messageId,
    MessageStatus? status,
    DateTime? timestamp,
    Map<String, ReactionModel>? reactions,
    bool? isFromMe,
    bool? isForwarded,
    bool? isSelected,
    bool clearReply = false,
    MessageContentType? type,
  }) {
    return LocationMessageModel(
      address: address,
      latitude: latitude,
      longitude: longitude,
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

  factory LocationMessageModel.fromJson(Map<String, dynamic> json) => LocationMessageModel(
        latitude: json[latitudeSerializedName],
        longitude: json[longitudeSerializedName],
        address: json[addressSerializedName],
        // parent props:
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
        latitudeSerializedName: latitude,
        longitudeSerializedName: longitude,
        addressSerializedName: address,
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
