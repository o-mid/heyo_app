import 'dart:async';

import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/data/models/messages/message_model.dart';
import 'package:heyo/app/modules/messages/data/models/metadatas/audio_metadata.dart';
import 'package:heyo/app/modules/messages/data/repo/messages_abstract_repo.dart';
import 'package:heyo/app/modules/messages/data/usecases/delete_message_usecase.dart';
import 'package:heyo/app/modules/messages/domain/message_repository.dart';
import 'package:heyo/app/modules/messages/domain/message_repository_models.dart';
import 'usecases/update_message_usecase.dart';

class MessageRepositoryImpl implements MessageRepository {
  MessageRepositoryImpl({
    required this.messagesRepo,
  });
  final MessagesAbstractRepo messagesRepo;

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
}
