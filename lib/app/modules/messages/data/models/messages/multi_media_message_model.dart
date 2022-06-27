import 'package:heyo/app/modules/messages/data/models/messages/image_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/message_model.dart';
import 'package:heyo/app/modules/messages/data/models/reaction_model.dart';

class MultiMediaMessageModel extends MessageModel {
  final List<dynamic> mediaList;

  MultiMediaMessageModel({
    required this.mediaList,
    required super.messageId,
    required super.timestamp,
    required super.isFromMe,
    required super.senderName,
    required super.senderAvatar,
    super.isForwarded,
    super.isSelected,
    bool clearReply = false,
    super.status = MESSAGE_STATUS.SENDING,
    super.type = CONTENT_TYPE.MULTI_MEDIA,
    super.replyTo,
    super.reactions = const <String, ReactionModel>{},
  });

  @override
  MultiMediaMessageModel copyWith({
    List<ImageMessageModel>? mediaList,
    String? messageId,
    MESSAGE_STATUS? status,
    CONTENT_TYPE? type,
    DateTime? timestamp,
    Map<String, ReactionModel>? reactions,
    bool clearReply = false,
    bool? isFromMe,
    bool? isForwarded,
    bool? isSelected,
  }) {
    return MultiMediaMessageModel(
        mediaList: mediaList ?? this.mediaList,
        messageId: messageId ?? this.messageId,
        timestamp: timestamp ?? this.timestamp,
        senderName: senderName,
        senderAvatar: senderAvatar,
        reactions: reactions ?? this.reactions,
        status: status ?? this.status,
        replyTo: clearReply ? null : replyTo,
        isFromMe: isFromMe ?? this.isFromMe,
        isForwarded: isForwarded ?? this.isForwarded,
        type: type ?? this.type,
        isSelected: isSelected ?? this.isSelected);
  }
}
