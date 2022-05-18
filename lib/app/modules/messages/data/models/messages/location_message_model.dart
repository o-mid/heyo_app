import 'package:heyo/app/modules/messages/data/models/messages/message_model.dart';
import 'package:heyo/app/modules/messages/data/models/reaction_model.dart';

class LocationMessageModel extends MessageModel {
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
    super.status = MESSAGE_STATUS.SENDING,
    super.isFromMe = false,
    super.isForwarded = false,
    super.isSelected = false,
    super.replyTo,
    super.reactions = const <String, ReactionModel>{},
  });

  @override
  MessageModel copyWith({
    String? messageId,
    MESSAGE_STATUS? status,
    DateTime? timestamp,
    Map<String, ReactionModel>? reactions,
    bool? isFromMe,
    bool? isForwarded,
    bool? isSelected,
    bool clearReply = false,
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
    );
  }
}
