import 'package:heyo/app/modules/messages/data/models/messages/image_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/message_model.dart';
import 'package:heyo/app/modules/messages/data/models/reaction_model.dart';

class MultiMediaMessageModel extends MessageModel {
  final List<ImageMessageModel> mediaList;

  MultiMediaMessageModel({
    required this.mediaList,
    required super.messageId,
    required super.timestamp,
    required super.senderName,
    required super.senderAvatar,
    bool? isFromMe,
    bool? isForwarded,
    bool? isSelected,
    bool clearReply = false,
    super.status = MESSAGE_STATUS.SENDING,
    super.replyTo,
    super.reactions = const <String, ReactionModel>{},
  });

  @override
  MultiMediaMessageModel copyWith({
    List<ImageMessageModel>? mediaList,
    String? messageId,
    MESSAGE_STATUS? status,
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
        isFromMe: isFromMe,
        isForwarded: isForwarded,
        isSelected: isSelected);
  }
}
