import 'package:heyo/app/modules/messages/data/models/messages/message_model.dart';
import 'package:heyo/app/modules/messages/data/models/reaction_model.dart';

enum CallMessageStatus {
  missed,
  declined,
}

enum CallMessageType {
  audio,
  video,
}

class CallMessageModel extends MessageModel {
  final CallMessageStatus callStatus;
  final CallMessageType callType;
  CallMessageModel({
    required this.callStatus,
    this.callType = CallMessageType.audio,
    required super.messageId,
    required super.timestamp,
    required super.senderName,
    required super.senderAvatar,
    super.status = MESSAGE_STATUS.SENDING,
    super.type = CONTENT_TYPE.CALL,
    super.isFromMe = false,
    super.isForwarded = false,
    super.isSelected = false,
    super.replyTo,
    super.reactions = const <String, ReactionModel>{},
  });

  @override
  CallMessageModel copyWith({
    String? messageId,
    MESSAGE_STATUS? status,
    DateTime? timestamp,
    Map<String, ReactionModel>? reactions,
    bool? isFromMe,
    bool? isForwarded,
    bool? isSelected,
    CONTENT_TYPE? type,
    bool clearReply = false,
  }) {
    return CallMessageModel(
      callStatus: callStatus,
      callType: callType,
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
