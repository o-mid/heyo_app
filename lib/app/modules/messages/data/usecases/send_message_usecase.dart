import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/data/models/messages/message_model.dart';
import 'package:heyo/app/modules/messages/data/models/metadatas/audio_metadata.dart';
import 'package:heyo/app/modules/messages/data/models/metadatas/file_metadata.dart';
import 'package:heyo/app/modules/messages/data/models/metadatas/image_metadata.dart';
import 'package:heyo/app/modules/messages/data/models/metadatas/video_metadata.dart';
import 'package:heyo/app/modules/messages/data/models/reply_to_model.dart';
import 'package:heyo/app/modules/messages/data/repo/messages_abstract_repo.dart';
import 'package:heyo/app/modules/messaging/controllers/common_messaging_controller.dart';
import 'package:tuple/tuple.dart';
import '../../../messaging/controllers/messaging_connection_controller.dart';
import '../../../messaging/usecases/send_data_channel_message_usecase.dart';
import '../../utils/message_from_type.dart';
import '../models/reaction_model.dart';
import '../provider/messages_provider.dart';
import '../repo/messages_repo.dart';

class SendMessage {
  final MessagesAbstractRepo messagesRepo = MessagesRepo(
    messagesProvider: MessagesProvider(
      appDatabaseProvider: Get.find(),
    ),
  );
  final CommonMessagingConnectionController messagingConnection =
      Get.find<CommonMessagingConnectionController>();

  execute({required SendMessageType sendMessageType, required String remoteCoreId}) async {
    Tuple3<MessageModel?, bool, String> messageObject =
        messageFromType(messageType: sendMessageType);
    MessageModel? msg = messageObject.item1;
    bool isDataBinary = messageObject.item2;
    String messageLocalPath = messageObject.item3;

    if (msg == null) {
      return;
    }

    await messagesRepo.createMessage(
        message: msg.copyWith(status: MessageStatus.sending), chatId: sendMessageType.chatId);

    Map<String, dynamic> messageJson = msg.toJson();
    SendDataChannelMessage(messagingConnection: messagingConnection).execute(
      channelMessageType: ChannelMessageType.message(
          message: messageJson, isDataBinary: isDataBinary, messageLocalPath: messageLocalPath),
      remoteCoreId: remoteCoreId,
    );
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
