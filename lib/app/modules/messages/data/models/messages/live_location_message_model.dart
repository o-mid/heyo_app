import 'package:heyo/app/modules/messages/data/models/messages/message_model.dart';
import 'package:heyo/app/modules/messages/data/models/reaction_model.dart';

class LiveLocationMessageModel extends MessageModel {
  final double latitude;
  final double longitude;
  final DateTime endTime;
  LiveLocationMessageModel({
    required this.latitude,
    required this.longitude,
    required this.endTime,
    required super.messageId,
    required super.timestamp,
    required super.senderName,
    required super.senderAvatar,
    super.status = MESSAGE_STATUS.SENDING,
    super.type = CONTENT_TYPE.LIVE_LOCATION,
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
    MESSAGE_STATUS? status,
    CONTENT_TYPE? type,
    DateTime? timestamp,
    Map<String, ReactionModel>? reactions,
    bool? isFromMe,
    bool? isForwarded,
    bool? isSelected,
    bool clearReply = false,
  }) {
    return LiveLocationMessageModel(
      latitude: latitude,
      longitude: longitude,
      endTime: endTime ?? this.endTime,
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
}
