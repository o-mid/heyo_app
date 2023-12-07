import 'package:heyo/app/modules/messages/data/models/messages/audio_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/file_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/image_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/live_location_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/location_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/text_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/video_message_model.dart';

import '../data/usecases/send_message_usecase.dart';

extension mapToSendMessageType on MessageModel {
  SendMessageType? getSendMessageType(String chatId) {
    MessageModel messageModel = this;
    switch (messageModel.type) {
      case MessageContentType.text:
        {
          return SendMessageType.text(
              text: (messageModel as TextMessageModel).text,
              replyTo: messageModel.replyTo,
              chatId: chatId);
        }

      case MessageContentType.image:
        return SendMessageType.image(
          chatId: chatId,
          metadata: (messageModel as ImageMessageModel).metadata,
          path: (messageModel).url,
          replyTo: messageModel.replyTo,
        );

      case MessageContentType.video:
        return SendMessageType.video(
          chatId: chatId,
          metadata: (messageModel as VideoMessageModel).metadata,
          path: (messageModel).url,
          replyTo: messageModel.replyTo,
        );
      case MessageContentType.audio:
        return SendMessageType.audio(
          chatId: chatId,
          metadata: (messageModel as AudioMessageModel).metadata,
          path: (messageModel).url,
          replyTo: messageModel.replyTo,
        );
      case MessageContentType.file:
        return SendMessageType.file(
          chatId: chatId,
          metadata: (messageModel as FileMessageModel).metadata,
          replyTo: messageModel.replyTo,
        );

      case MessageContentType.location:
        return SendMessageType.location(
          chatId: chatId,
          address: (messageModel as LocationMessageModel).address,
          lat: messageModel.latitude,
          long: messageModel.longitude,
          replyTo: messageModel.replyTo,
        );
      case MessageContentType.liveLocation:
        return SendMessageType.liveLocation(
            chatId: chatId,
            replyTo: messageModel.replyTo,
            // TODO : Fix the correct time
            duration: const Duration(minutes: 40),
            startLat: (messageModel as LiveLocationMessageModel).latitude,
            startLong: messageModel.longitude);

      default:
        return null;
    }
  }
}

SendMessageType? get(MessageModel messageModel, String chatId) {
  switch (messageModel.type) {
    case MessageContentType.text:
      {
        return SendMessageType.text(
            text: (messageModel as TextMessageModel).text,
            replyTo: messageModel.replyTo,
            chatId: chatId);
      }

    case MessageContentType.image:
      return SendMessageType.image(
        chatId: chatId,
        metadata: (messageModel as ImageMessageModel).metadata,
        path: (messageModel).url,
        replyTo: messageModel.replyTo,
      );

    case MessageContentType.video:
      return SendMessageType.video(
        chatId: chatId,
        metadata: (messageModel as VideoMessageModel).metadata,
        path: (messageModel).url,
        replyTo: messageModel.replyTo,
      );
    case MessageContentType.audio:
      return SendMessageType.audio(
        chatId: chatId,
        metadata: (messageModel as AudioMessageModel).metadata,
        path: (messageModel).url,
        replyTo: messageModel.replyTo,
      );
    case MessageContentType.file:
      return SendMessageType.file(
        chatId: chatId,
        metadata: (messageModel as FileMessageModel).metadata,
        replyTo: messageModel.replyTo,
      );

    case MessageContentType.location:
      return SendMessageType.location(
        chatId: chatId,
        address: (messageModel as LocationMessageModel).address,
        lat: messageModel.latitude,
        long: messageModel.longitude,
        replyTo: messageModel.replyTo,
      );
    case MessageContentType.liveLocation:
      return SendMessageType.liveLocation(
          chatId: chatId,
          replyTo: messageModel.replyTo,
          // TODO : Fix the correct time
          duration: const Duration(minutes: 40),
          startLat: (messageModel as LiveLocationMessageModel).latitude,
          startLong: messageModel.longitude);

    default:
      return null;
  }
}
