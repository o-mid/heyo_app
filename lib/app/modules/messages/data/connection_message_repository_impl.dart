import 'dart:async';

import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/data/models/messages/message_model.dart';
import 'package:heyo/app/modules/messages/data/models/metadatas/audio_metadata.dart';
import 'package:heyo/app/modules/messages/data/repo/messages_abstract_repo.dart';
import 'package:heyo/app/modules/messages/data/usecases/delete_message_usecase.dart';
import 'package:heyo/app/modules/messages/domain/connection_message_repository.dart';
import 'package:heyo/app/modules/messages/domain/message_repository_models.dart';
import 'usecases/update_message_usecase.dart';

class ConnectionMessageRepositoryImpl implements ConnectionMessageRepository {
  final MessagesAbstractRepo messagesRepo;
  // final SendMessage sendMessage = Get.find<SendMessage>(); // Getting the SendMessage instance.
  // final DeleteMessage deleteMessage = Get.find<DeleteMessage>();
  // final UpdateMessage updateMessage = Get.find<UpdateMessage>();

  ConnectionMessageRepositoryImpl({
    required this.messagesRepo,
  });

  @override
  Future<Stream<List<MessageModel>>> getMessagesStream({required String coreId}) async {
    final messagesStream = await messagesRepo.getMessagesStream(coreId);
    return messagesStream;
  }

  @override
  Future<List<MessageModel>> getMessagesList({required String coreId}) async {
    final messagesList = await messagesRepo.getMessages(coreId);

    return messagesList;
  }

  @override
  Future<void> markAllMessagesAsRead({
    required String chatId,
  }) async {
    await messagesRepo.markAllMessagesAsRead(chatId: chatId);
  }

  @override
  Future<void> markMessagesAsReadById(
      {required String lastReadmessageId, required String chatId}) async {
    await messagesRepo.markMessagesAsRead(lastReadmessageId: lastReadmessageId, chatId: chatId);
  }

  // @override
  // Future<void> sendTextMessage({required SendTextMessageRepoModel sendTextMessageRepoModel}) async {
  //   final newMessageValue = sendTextMessageRepoModel.newMessageValue;
  //   final replyingToValue = sendTextMessageRepoModel.replyingToValue;
  //   final chatId = sendTextMessageRepoModel.chatId;
  //   final remoteCoreId = sendTextMessageRepoModel.remoteCoreId;

  //   await sendMessage.execute(
  //     sendMessageType: SendMessageType.text(
  //       text: newMessageValue,
  //       replyTo: replyingToValue,
  //       chatId: chatId,
  //     ),
  //     remoteCoreId: remoteCoreId,
  //   );
  // }

  // @override
  // Future<void> sendAudioMessage(
  //     {required SendAudioMessageRepoModel sendAudioMessageRepoModel}) async {
  //   final path = sendAudioMessageRepoModel.path;
  //   final duration = sendAudioMessageRepoModel.duration;
  //   final replyingToValue = sendAudioMessageRepoModel.replyingToValue;
  //   final chatId = sendAudioMessageRepoModel.chatId;
  //   final remoteCoreId = sendAudioMessageRepoModel.remoteCoreId;

  //   await sendMessage.execute(
  //     sendMessageType: SendMessageType.audio(
  //       path: path,
  //       metadata: AudioMetadata(durationInSeconds: duration),
  //       replyTo: replyingToValue,
  //       chatId: chatId,
  //     ),
  //     remoteCoreId: remoteCoreId,
  //   );
  // }

  // @override
  // Future<void> sendLocationMessage(
  //     {required SendLocationMessageRepoModel sendLocationMessageRepoModel}) async {
  //   final latitude = sendLocationMessageRepoModel.latitude;
  //   final longitude = sendLocationMessageRepoModel.longitude;
  //   final address = sendLocationMessageRepoModel.address;
  //   final replyingToValue = sendLocationMessageRepoModel.replyingToValue;
  //   final chatId = sendLocationMessageRepoModel.chatId;
  //   final remoteCoreId = sendLocationMessageRepoModel.remoteCoreId;

  //   await sendMessage.execute(
  //     sendMessageType: SendMessageType.location(
  //       lat: latitude,
  //       long: longitude,
  //       address: address,
  //       replyTo: replyingToValue,
  //       chatId: chatId,
  //     ),
  //     remoteCoreId: remoteCoreId,
  //   );
  // }

  // @override
  // Future<void> sendLiveLocation({
  //   required SendLiveLocationRepoModel sendLiveLocationRepoModel,
  // }) async {
  //   final startLat = sendLiveLocationRepoModel.startLat;
  //   final startLong = sendLiveLocationRepoModel.startLong;
  //   final duration = sendLiveLocationRepoModel.duration;
  //   final replyingToValue = sendLiveLocationRepoModel.replyingToValue;
  //   final chatId = sendLiveLocationRepoModel.chatId;
  //   final remoteCoreId = sendLiveLocationRepoModel.remoteCoreId;

  //   await sendMessage.execute(
  //     sendMessageType: SendMessageType.liveLocation(
  //       startLat: startLat,
  //       startLong: startLong,
  //       duration: duration,
  //       replyTo: replyingToValue,
  //       chatId: chatId,
  //     ),
  //     remoteCoreId: remoteCoreId,
  //   );
  // }

  // @override
  // Future<void> sendFileMessage({required SendFileMessageRepoModel sendFileMessageRepoModel}) async {
  //   final metadata = sendFileMessageRepoModel.metadata;
  //   final replyingToValue = sendFileMessageRepoModel.replyingToValue;
  //   final chatId = sendFileMessageRepoModel.chatId;
  //   final remoteCoreId = sendFileMessageRepoModel.remoteCoreId;

  //   await sendMessage.execute(
  //     sendMessageType: SendMessageType.file(
  //       metadata: metadata,
  //       replyTo: replyingToValue,
  //       chatId: chatId,
  //     ),
  //     remoteCoreId: remoteCoreId,
  //   );
  // }

  // @override
  // Future<void> deleteMessages({required DeleteMessageRepoModel deleteMessageRepoModel}) async {
  //   final selectedMessages = deleteMessageRepoModel.selectedMessages;
  //   final chatId = deleteMessageRepoModel.chatId;
  //   final remoteCoreId = deleteMessageRepoModel.remoteCoreId;
  //   final deleteForEveryOne = deleteMessageRepoModel.deleteForEveryOne;

  //   final deleteMessageType = deleteForEveryOne
  //       ? DeleteMessageType.forEveryone(
  //           selectedMessages: selectedMessages,
  //           chatId: chatId,
  //         )
  //       : DeleteMessageType.forMe(
  //           selectedMessages: selectedMessages,
  //           chatId: chatId,
  //         );

  //   await deleteMessage.execute(
  //     remoteCoreId: remoteCoreId,
  //     deleteMessageType: deleteMessageType,
  //   );
  // }

  // @override
  // Future<void> updateReactions({required UpdateMessageRepoModel updateMessageRepoModel}) async {
  //   final selectedMessage = updateMessageRepoModel.selectedMessage;
  //   final emoji = updateMessageRepoModel.emoji;
  //   final chatId = updateMessageRepoModel.chatId;
  //   final remoteCoreId = updateMessageRepoModel.remoteCoreId;

  //   await updateMessage.execute(
  //     remoteCoreId: remoteCoreId,
  //     updateMessageType: UpdateMessageType.updateReactions(
  //       selectedMessage: selectedMessage,
  //       emoji: emoji,
  //       chatId: chatId,
  //     ),
  //   );
  // }
}
