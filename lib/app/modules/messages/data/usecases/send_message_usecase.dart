import 'dart:convert';
import 'dart:io';

import 'package:heyo/app/modules/messages/data/models/metadatas/file_metadata.dart';
import 'package:heyo/app/modules/messages/data/models/metadatas/image_metadata.dart';
import 'package:heyo/app/modules/messages/data/models/reaction_model.dart';
import 'package:heyo/app/modules/messages/data/models/reply_to_model.dart';
import 'package:heyo/app/modules/messages/connection/connection_repo.dart';
import 'package:heyo/app/modules/messages/connection/models/data_channel_message_model.dart';
import 'package:tuple/tuple.dart';

import '../../connection/models/models.dart';
import '../../utils/message_from_type.dart';
import '../message_processor.dart';
import '../models/messages/message_model.dart';
import '../models/metadatas/audio_metadata.dart';
import '../models/metadatas/video_metadata.dart';
import '../repo/messages_abstract_repo.dart';

class SendMessageUseCase {
  SendMessageUseCase({
    required this.messagesRepo,
    required this.connectionRepository,
    required this.processor,
  });

  final MessagesAbstractRepo messagesRepo;
  final MessageProcessor processor;
  final ConnectionRepository connectionRepository;

  execute(
      {required MessageConnectionType messageConnectionType,
      required SendMessageType sendMessageType,
      required List<String> remoteCoreIds,
      required String chatName,
      bool isUpdate = false,
      MessageModel? messageModel = null}) async {
    Tuple3<MessageModel?, bool, String> messageObject =
        messageFromType(messageType: sendMessageType, messageModel: messageModel);
    MessageModel? msg = messageObject.item1;
    bool isDataBinary = messageObject.item2;
    String messageLocalPath = messageObject.item3;

    if (msg == null) {
      return;
    }
    if (isUpdate) {
      await messagesRepo.updateMessage(
          message: msg.copyWith(status: MessageStatus.sending), chatId: sendMessageType.chatId);
    } else {
      await messagesRepo.createMessage(
          message: msg.copyWith(status: MessageStatus.sending), chatId: sendMessageType.chatId);
    }

    final rawmessageJson = msg.toJson();

    final processedMessage = await processor.getMessageDetails(
      channelMessageType: ChannelMessageType.message(
        message: rawmessageJson,
        isDataBinary: isDataBinary,
        messageLocalPath: messageLocalPath,
        remoteCoreIds: remoteCoreIds,
        chatId: msg.chatId,
        //TODO : Group chat name
        chatName: chatName,
      ),
    );
    if (isDataBinary && messageLocalPath.isNotEmpty) {
      // Todo: implement sending binary data

      // BinaryFileSendingState sendingState = await BinaryFileSendingState.create(
      //   file: File(messageLocalPath),
      //   meta: processedMessage.messageJson,
      // );
      // await SendBinaryData(sendingState: sendingState, messagingConnection: messagingConnection)
      //     .execute(remoteCoreId);
      // messagingConnection.sendBinaryMessage(binary: binary, remoteCoreId: remoteCoreId)
    } else {
      await connectionRepository.sendTextMessage(
        messageConnectionType: messageConnectionType,
        text: jsonEncode(processedMessage.messageJson),
        remoteCoreIds: remoteCoreIds,
      );
    }
  }
}

class SendMessageType {
  final ReplyToModel? replyTo;
  final String chatId;
  final Map<String, ReactionModel> reactions;

  SendMessageType(
      {required this.replyTo,
      required this.chatId,
      this.reactions = const <String, ReactionModel>{}});

  factory SendMessageType.text({
    required String text,
    required ReplyToModel? replyTo,
    required String chatId,
  }) = SendTextMessage;

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
