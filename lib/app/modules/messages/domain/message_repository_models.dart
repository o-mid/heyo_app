import 'package:heyo/app/modules/messages/data/models/reply_to_model.dart';

import '../data/models/metadatas/file_metadata.dart';

class UserInstance {
  String coreId;
  String? iconUrl;
  UserInstance({required this.coreId, this.iconUrl});
}

class UserStates {
  String lastReadRemoteMessagesId;
  String scrollPositionMessagesId;
  String chatId;

  DateTime lastMessageTimestamp;
  String lastMessagePreview;
  UserStates(
      {required this.lastReadRemoteMessagesId,
      required this.scrollPositionMessagesId,
      required this.chatId,
      required this.lastMessagePreview,
      required this.lastMessageTimestamp});
}

class SendTextMessageRepoModel {
  final String newMessageValue;
  final ReplyToModel? replyingToValue;
  final String chatId;
  final String remoteCoreId;

  SendTextMessageRepoModel({
    required this.newMessageValue,
    required this.chatId,
    required this.remoteCoreId,
    this.replyingToValue,
  });
}

class SendAudioMessageRepoModel {
  final String path;
  final int duration;
  final ReplyToModel? replyingToValue;
  final String chatId;
  final String remoteCoreId;

  SendAudioMessageRepoModel({
    required this.path,
    required this.duration,
    required this.chatId,
    required this.remoteCoreId,
    this.replyingToValue,
  });
}

class SendLocationMessageRepoModel {
  final double latitude;
  final double longitude;
  final String address;
  final ReplyToModel? replyingToValue;
  final String chatId;
  final String remoteCoreId;

  SendLocationMessageRepoModel({
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.chatId,
    required this.remoteCoreId,
    this.replyingToValue,
  });
}

class SendLiveLocationRepoModel {
  final double startLat;
  final double startLong;
  final Duration duration;
  final ReplyToModel? replyingToValue;
  final String chatId;
  final String remoteCoreId;

  SendLiveLocationRepoModel({
    required this.startLat,
    required this.startLong,
    required this.duration,
    required this.chatId,
    required this.remoteCoreId,
    this.replyingToValue,
  });
}

class SendFileMessageRepoModel {
  final FileMetaData metadata;
  final ReplyToModel? replyingToValue;
  final String chatId;
  final String remoteCoreId;

  SendFileMessageRepoModel({
    required this.metadata,
    required this.chatId,
    required this.remoteCoreId,
    this.replyingToValue,
  });
}
