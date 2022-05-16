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
  MessageModel copyWith({
    DateTime? endTime,
    String? messageId,
    MESSAGE_STATUS? status,
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
    );
  }
}
