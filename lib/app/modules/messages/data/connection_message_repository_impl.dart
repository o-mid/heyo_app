import 'dart:async';

import 'package:heyo/app/modules/messages/data/models/messages/message_model.dart';
import 'package:heyo/app/modules/messages/data/repo/messages_abstract_repo.dart';
import 'package:heyo/app/modules/messages/domain/connection_message_repository.dart';

class ConnectionMessageRepositoryImpl implements ConnectionMessageRepository {
  final MessagesAbstractRepo messagesRepo;

  ConnectionMessageRepositoryImpl({
    required this.messagesRepo,
  });

  @override
  Future<Stream<List<MessageModel>>> getMessagesStream({required String coreId}) async {
    Stream<List<MessageModel>> messagesStream = await messagesRepo.getMessagesStream(coreId);
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
