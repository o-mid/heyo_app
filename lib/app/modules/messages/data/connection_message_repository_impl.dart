import 'dart:async';

import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/data/models/messages/message_model.dart';
import 'package:heyo/app/modules/messages/data/models/reply_to_model.dart';
import 'package:heyo/app/modules/messages/data/repo/messages_abstract_repo.dart';
import 'package:heyo/app/modules/messages/data/usecases/send_message_usecase.dart';
import 'package:heyo/app/modules/messages/domain/connection_message_repository.dart';
import 'package:heyo/app/modules/messages/domain/message_repository_models.dart';

class ConnectionMessageRepositoryImpl implements ConnectionMessageRepository {
  final MessagesAbstractRepo messagesRepo;
  final SendMessage sendMessage = Get.find<SendMessage>(); // Getting the SendMessage instance.

  ConnectionMessageRepositoryImpl({
    required this.messagesRepo,
  });

  @override
  Future<Stream<List<MessageModel>>> getMessagesStream({required String coreId}) async {
    final Stream<List<MessageModel>> messagesStream = await messagesRepo.getMessagesStream(coreId);
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

  @override
  Future<void> sendTextMessage({required SendMessageRepoModel sendMessageRepoModel}) async {
    final newMessageValue = sendMessageRepoModel.newMessageValue;
    final replyingToValue = sendMessageRepoModel.replyingToValue;
    final chatId = sendMessageRepoModel.chatId;
    final remoteCoreId = sendMessageRepoModel.remoteCoreId;

    await sendMessage.execute(
      sendMessageType: SendMessageType.text(
        text: newMessageValue,
        replyTo: replyingToValue,
        chatId: chatId,
      ),
      remoteCoreId: remoteCoreId,
    );
  }
}
