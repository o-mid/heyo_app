import 'package:heyo/app/modules/messages/data/models/messages/audio_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/live_location_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/location_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/text_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/metadatas/audio_metadata.dart';
import 'package:heyo/app/modules/messages/data/models/reply_to_model.dart';
import 'package:heyo/app/modules/messages/data/repo/messages_abstract_repo.dart';

class SendMessage {
  final MessagesAbstractRepo messagesRepo;

  SendMessage({required this.messagesRepo});

  factory SendMessage.text({
    required String text,
    required MessagesAbstractRepo messagesRepo,
  }) = SendTextMessage;

  factory SendMessage.audio({
    required String path,
    required AudioMetadata metadata,
    required MessagesAbstractRepo messagesRepo,
  }) = SendAudioMessage;

  factory SendMessage.location({
    required double lat,
    required double long,
    required String address,
    required MessagesAbstractRepo messagesRepo,
  }) = SendLocationMessage;

  factory SendMessage.liveLocation({
    required double startLat,
    required double startLong,
    required Duration duration,
    required MessagesAbstractRepo messagesRepo,
  }) = SendLiveLocationMessage;

  Future<void> execute({required ReplyToModel? replyTo, required String chatId}) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString(); // Todo: use uuid
    final timestamp = DateTime.now();
    const senderName = ""; // Todo: get sender name from user repo
    const senderAvatar = ""; // Todo: get sender avatar from user repo

    MessageModel? msg;
    switch (runtimeType) {
      case SendTextMessage:
        msg = TextMessageModel(
          text: (this as SendTextMessage).text,
          messageId: id,
          timestamp: timestamp,
          senderName: senderName,
          senderAvatar: senderAvatar,
          replyTo: replyTo,
          type: MessageContentType.text,
          status: MessageStatus.sending,
          isFromMe: true,
        );
        break;
      case SendAudioMessage:
        msg = AudioMessageModel(
          url: "",
          localUrl: (this as SendAudioMessage).path,
          metadata: (this as SendAudioMessage).metadata,
          messageId: id,
          timestamp: timestamp,
          senderName: senderName,
          senderAvatar: senderAvatar,
          replyTo: replyTo,
          type: MessageContentType.audio,
          status: MessageStatus.sending,
          isFromMe: true,
        );
        break;
      case SendLocationMessage:
        msg = LocationMessageModel(
          latitude: (this as SendLocationMessage).lat,
          longitude: (this as SendLocationMessage).long,
          address: (this as SendLocationMessage).address,
          messageId: id,
          timestamp: timestamp,
          senderName: senderName,
          senderAvatar: senderAvatar,
          replyTo: replyTo,
          type: MessageContentType.location,
          status: MessageStatus.sending,
          isFromMe: true,
        );
        break;
      case SendLiveLocationMessage:
        msg = LiveLocationMessageModel(
          latitude: (this as SendLiveLocationMessage).startLat,
          longitude: (this as SendLiveLocationMessage).startLong,
          endTime: DateTime.now().add((this as SendLiveLocationMessage).duration),
          messageId: id,
          timestamp: timestamp,
          senderName: senderName,
          senderAvatar: senderAvatar,
          replyTo: replyTo,
          type: MessageContentType.liveLocation,
          status: MessageStatus.sending,
          isFromMe: true,
        );
        break;
    }

    if (msg == null) {
      return;
    }

    await messagesRepo.createMessage(message: msg, chatId: chatId);
  }
}

class SendTextMessage extends SendMessage {
  final String text;

  SendTextMessage({
    required this.text,
    required super.messagesRepo,
  });
}

class SendAudioMessage extends SendMessage {
  final String path;
  final AudioMetadata metadata;

  SendAudioMessage({
    required this.path,
    required this.metadata,
    required super.messagesRepo,
  });
}

class SendLocationMessage extends SendMessage {
  final double lat;
  final double long;
  final String address;

  SendLocationMessage({
    required this.lat,
    required this.long,
    required this.address,
    required super.messagesRepo,
  });
}

class SendLiveLocationMessage extends SendMessage {
  final double startLat;
  final double startLong;
  final Duration duration;

  SendLiveLocationMessage({
    required this.startLat,
    required this.startLong,
    required this.duration,
    required super.messagesRepo,
  });
}
