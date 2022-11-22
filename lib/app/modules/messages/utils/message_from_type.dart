import 'package:tuple/tuple.dart';
import 'package:uuid/uuid.dart';

import 'package:heyo/app/modules/messages/data/models/messages/audio_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/image_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/live_location_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/location_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/text_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/video_message_model.dart';

import '../data/models/messages/file_message_model.dart';

import '../data/usecases/send_message_usecase.dart';

Tuple2<MessageModel?, bool> messageFromType({required SendMessageType messageType}) {
  bool isDataBinery = false;
  var uuid = const Uuid();
  final id = uuid.v4();
  final timestamp = DateTime.now();
  const senderName = ""; // Todo: get sender name from user repo
  const senderAvatar = ""; // Todo: get sender avatar from user repo
  MessageModel? msg;
  switch (messageType.runtimeType) {
    case SendTextMessage:
      msg = TextMessageModel(
          text: (messageType as SendTextMessage).text,
          messageId: id,
          timestamp: timestamp,
          senderName: senderName,
          senderAvatar: senderAvatar,
          replyTo: messageType.replyTo,
          type: MessageContentType.text,
          status: MessageStatus.sending,
          isFromMe: true,
          reactions: messageType.reactions);

      break;
    case SendAudioMessage:
      msg = AudioMessageModel(
        url: "",
        localUrl: (messageType as SendAudioMessage).path,
        metadata: (messageType).metadata,
        messageId: id,
        timestamp: timestamp,
        senderName: senderName,
        senderAvatar: senderAvatar,
        replyTo: messageType.replyTo,
        type: MessageContentType.audio,
        status: MessageStatus.sending,
        isFromMe: true,
      );
      break;
    case SendLocationMessage:
      msg = LocationMessageModel(
        latitude: (messageType as SendLocationMessage).lat,
        longitude: (messageType).long,
        address: (messageType).address,
        messageId: id,
        timestamp: timestamp,
        senderName: senderName,
        senderAvatar: senderAvatar,
        replyTo: messageType.replyTo,
        type: MessageContentType.location,
        status: MessageStatus.sending,
        isFromMe: true,
      );
      break;
    case SendLiveLocationMessage:
      msg = LiveLocationMessageModel(
        latitude: (messageType as SendLiveLocationMessage).startLat,
        longitude: (messageType).startLong,
        endTime: DateTime.now().add((messageType).duration),
        messageId: id,
        timestamp: timestamp,
        senderName: senderName,
        senderAvatar: senderAvatar,
        replyTo: messageType.replyTo,
        type: MessageContentType.liveLocation,
        status: MessageStatus.sending,
        isFromMe: true,
      );
      break;
    case SendImageMessage:
      msg = ImageMessageModel(
        url: (messageType as SendImageMessage).path,
        intlist: (messageType).intlist,
        metadata: (messageType).metadata,
        isLocal: true,
        messageId: id,
        timestamp: timestamp,
        senderName: senderName,
        senderAvatar: senderAvatar,
        replyTo: messageType.replyTo,
        type: MessageContentType.image,
        status: MessageStatus.sending,
        isFromMe: true,
      );
      isDataBinery = true;
      break;
    case SendVideoMessage:
      msg = VideoMessageModel(
        url: (messageType as SendVideoMessage).path,
        metadata: (messageType).metadata,
        messageId: id,
        timestamp: timestamp,
        senderName: senderName,
        senderAvatar: senderAvatar,
        replyTo: messageType.replyTo,
        type: MessageContentType.video,
        status: MessageStatus.sending,
        isFromMe: true,
      );
      break;
    case SendFileMessage:
      msg = FileMessageModel(
        metadata: (messageType as SendFileMessage).metadata,
        messageId: id,
        timestamp: timestamp,
        senderName: senderName,
        senderAvatar: senderAvatar,
        replyTo: messageType.replyTo,
        type: MessageContentType.file,
        status: MessageStatus.sending,
        isFromMe: true,
      );
      break;
  }

  return Tuple2(msg, isDataBinery);
}
