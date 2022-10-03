import 'package:heyo/app/modules/messages/data/models/messages/audio_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/image_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/live_location_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/location_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/text_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/video_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/metadatas/audio_metadata.dart';
import 'package:heyo/app/modules/messages/data/models/metadatas/file_metadata.dart';
import 'package:heyo/app/modules/messages/data/models/metadatas/image_metadata.dart';
import 'package:heyo/app/modules/messages/data/models/metadatas/video_metadata.dart';
import 'package:heyo/app/modules/messages/data/models/reply_to_model.dart';
import 'package:heyo/app/modules/messages/data/repo/messages_abstract_repo.dart';
import 'package:uuid/uuid.dart';

import '../models/messages/file_message_model.dart';

class SendMessage {
  final MessagesAbstractRepo messagesRepo;

  SendMessage({required this.messagesRepo});

  execute({
    required SendMessageType sendMessageType,
  }) async {
    var uuid = const Uuid();
    final id = uuid.v4();
    final timestamp = DateTime.now();
    const senderName = ""; // Todo: get sender name from user repo
    const senderAvatar = ""; // Todo: get sender avatar from user repo

    MessageModel? msg;
    switch (sendMessageType.runtimeType) {
      case SendTextMessage:
        msg = TextMessageModel(
          text: (sendMessageType as SendTextMessage).text,
          messageId: id,
          timestamp: timestamp,
          senderName: senderName,
          senderAvatar: senderAvatar,
          replyTo: sendMessageType.replyTo,
          type: MessageContentType.text,
          status: MessageStatus.sending,
          isFromMe: true,
        );
        break;
      case SendAudioMessage:
        msg = AudioMessageModel(
          url: "",
          localUrl: (sendMessageType as SendAudioMessage).path,
          metadata: (sendMessageType).metadata,
          messageId: id,
          timestamp: timestamp,
          senderName: senderName,
          senderAvatar: senderAvatar,
          replyTo: sendMessageType.replyTo,
          type: MessageContentType.audio,
          status: MessageStatus.sending,
          isFromMe: true,
        );
        break;
      case SendLocationMessage:
        msg = LocationMessageModel(
          latitude: (sendMessageType as SendLocationMessage).lat,
          longitude: (sendMessageType).long,
          address: (sendMessageType).address,
          messageId: id,
          timestamp: timestamp,
          senderName: senderName,
          senderAvatar: senderAvatar,
          replyTo: sendMessageType.replyTo,
          type: MessageContentType.location,
          status: MessageStatus.sending,
          isFromMe: true,
        );
        break;
      case SendLiveLocationMessage:
        msg = LiveLocationMessageModel(
          latitude: (sendMessageType as SendLiveLocationMessage).startLat,
          longitude: (sendMessageType).startLong,
          endTime: DateTime.now().add((sendMessageType).duration),
          messageId: id,
          timestamp: timestamp,
          senderName: senderName,
          senderAvatar: senderAvatar,
          replyTo: sendMessageType.replyTo,
          type: MessageContentType.liveLocation,
          status: MessageStatus.sending,
          isFromMe: true,
        );
        break;
      case SendImageMessage:
        msg = ImageMessageModel(
          url: (sendMessageType as SendImageMessage).path,
          metadata: (sendMessageType).metadata,
          isLocal: true,
          messageId: id,
          timestamp: timestamp,
          senderName: senderName,
          senderAvatar: senderAvatar,
          replyTo: sendMessageType.replyTo,
          type: MessageContentType.image,
          status: MessageStatus.sending,
          isFromMe: true,
        );
        break;
      case SendVideoMessage:
        msg = VideoMessageModel(
          url: (sendMessageType as SendVideoMessage).path,
          metadata: (sendMessageType).metadata,
          messageId: id,
          timestamp: timestamp,
          senderName: senderName,
          senderAvatar: senderAvatar,
          replyTo: sendMessageType.replyTo,
          type: MessageContentType.video,
          status: MessageStatus.sending,
          isFromMe: true,
        );
        break;
      case SendFileMessage:
        msg = FileMessageModel(
          metadata: (sendMessageType as SendFileMessage).metadata,
          messageId: id,
          timestamp: timestamp,
          senderName: senderName,
          senderAvatar: senderAvatar,
          replyTo: sendMessageType.replyTo,
          type: MessageContentType.file,
          status: MessageStatus.sending,
          isFromMe: true,
        );
        break;
    }

    if (msg == null) {
      return;
    }

    await messagesRepo.createMessage(message: msg, chatId: sendMessageType.chatId);
  }
}

class SendMessageType {
  final ReplyToModel? replyTo;
  final String chatId;

  SendMessageType({required this.replyTo, required this.chatId});
  factory SendMessageType.text(
      {required String text,
      required ReplyToModel? replyTo,
      required String chatId}) = SendTextMessage;

  factory SendMessageType.audio(
      {required String path,
      required AudioMetadata metadata,
      required ReplyToModel? replyTo,
      required String chatId}) = SendAudioMessage;

  factory SendMessageType.location(
      {required double lat,
      required double long,
      required String address,
      required ReplyToModel? replyTo,
      required String chatId}) = SendLocationMessage;

  factory SendMessageType.liveLocation(
      {required double startLat,
      required double startLong,
      required Duration duration,
      required ReplyToModel? replyTo,
      required String chatId}) = SendLiveLocationMessage;

  factory SendMessageType.image(
      {required String path,
      required ImageMetadata metadata,
      required ReplyToModel? replyTo,
      required String chatId}) = SendImageMessage;

  factory SendMessageType.video(
      {required String path,
      required VideoMetadata metadata,
      required ReplyToModel? replyTo,
      required String chatId}) = SendVideoMessage;

  factory SendMessageType.file(
      {required FileMetaData metadata,
      required ReplyToModel? replyTo,
      required String chatId}) = SendFileMessage;
}

class SendTextMessage extends SendMessageType {
  final String text;

  SendTextMessage({
    required this.text,
    required super.replyTo,
    required super.chatId,
  });
}

class SendAudioMessage extends SendMessageType {
  final String path;
  final AudioMetadata metadata;

  SendAudioMessage({
    required this.path,
    required this.metadata,
    required super.replyTo,
    required super.chatId,
  });
}

class SendLocationMessage extends SendMessageType {
  final double lat;
  final double long;
  final String address;

  SendLocationMessage(
      {required this.lat,
      required this.long,
      required this.address,
      required super.replyTo,
      required super.chatId});
}

class SendLiveLocationMessage extends SendMessageType {
  final double startLat;
  final double startLong;
  final Duration duration;

  SendLiveLocationMessage(
      {required this.startLat,
      required this.startLong,
      required this.duration,
      required super.replyTo,
      required super.chatId});
}

class SendImageMessage extends SendMessageType {
  final String path;
  final ImageMetadata metadata;

  SendImageMessage({
    required this.path,
    required this.metadata,
    required super.replyTo,
    required super.chatId,
  });
}

class SendVideoMessage extends SendMessageType {
  final String path;
  final VideoMetadata metadata;

  SendVideoMessage({
    required this.path,
    required this.metadata,
    required super.replyTo,
    required super.chatId,
  });
}

class SendFileMessage extends SendMessageType {
  final FileMetaData metadata;

  SendFileMessage({
    required this.metadata,
    required super.replyTo,
    required super.chatId,
  });
}
