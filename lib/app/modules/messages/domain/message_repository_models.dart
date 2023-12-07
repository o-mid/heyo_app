import 'package:heyo/app/modules/messages/data/models/messages/message_model.dart';
import 'package:heyo/app/modules/messages/data/models/reply_to_model.dart';

import '../data/models/metadatas/file_metadata.dart';

class UserInstance {
  UserInstance({required this.coreId, this.iconUrl});
  String coreId;
  String? iconUrl;
}

class UserStates {
  UserStates(
      {required this.lastReadRemoteMessagesId,
      required this.scrollPositionMessagesId,
      required this.chatId,
      required this.lastMessagePreview,
      required this.lastMessageTimestamp});
  String lastReadRemoteMessagesId;
  String scrollPositionMessagesId;
  String chatId;

  DateTime lastMessageTimestamp;
  String lastMessagePreview;
}

// class SendTextMessageRepoModel {
//   SendTextMessageRepoModel({
//     required this.newMessageValue,
//     required this.chatId,
//     required this.remoteCoreId,
//     this.replyingToValue,
//   });
//   final String newMessageValue;
//   final ReplyToModel? replyingToValue;
//   final String chatId;
//   final String remoteCoreId;
// }

// class SendAudioMessageRepoModel {
//   SendAudioMessageRepoModel({
//     required this.path,
//     required this.duration,
//     required this.chatId,
//     required this.remoteCoreId,
//     this.replyingToValue,
//   });
//   final String path;
//   final int duration;
//   final ReplyToModel? replyingToValue;
//   final String chatId;
//   final String remoteCoreId;
// }

// class SendLocationMessageRepoModel {
//   SendLocationMessageRepoModel({
//     required this.latitude,
//     required this.longitude,
//     required this.address,
//     required this.chatId,
//     required this.remoteCoreId,
//     this.replyingToValue,
//   });
//   final double latitude;
//   final double longitude;
//   final String address;
//   final ReplyToModel? replyingToValue;
//   final String chatId;
//   final String remoteCoreId;
// }

// class SendLiveLocationRepoModel {
//   SendLiveLocationRepoModel({
//     required this.startLat,
//     required this.startLong,
//     required this.duration,
//     required this.chatId,
//     required this.remoteCoreId,
//     this.replyingToValue,
//   });
//   final double startLat;
//   final double startLong;
//   final Duration duration;
//   final ReplyToModel? replyingToValue;
//   final String chatId;
//   final String remoteCoreId;
// }

// class SendFileMessageRepoModel {
//   SendFileMessageRepoModel({
//     required this.metadata,
//     required this.chatId,
//     required this.remoteCoreId,
//     this.replyingToValue,
//   });
//   final FileMetaData metadata;
//   final ReplyToModel? replyingToValue;
//   final String chatId;
//   final String remoteCoreId;
// }

// class DeleteMessageRepoModel {
//   DeleteMessageRepoModel({
//     required this.selectedMessages,
//     required this.chatId,
//     required this.remoteCoreId,
//     required this.deleteForEveryOne,
//   });
//   final List<MessageModel> selectedMessages;
//   final String chatId;
//   final String remoteCoreId;
//   final bool deleteForEveryOne;
// }

// class UpdateMessageRepoModel {
//   UpdateMessageRepoModel({
//     required this.selectedMessage,
//     required this.emoji,
//     required this.chatId,
//     required this.remoteCoreId,
//   });
//   final MessageModel selectedMessage;
//   final String emoji;
//   final String chatId;
//   final String remoteCoreId;
// }
