import 'dart:async';
import '../data/models/messages/message_model.dart';

abstract class MessageRepository {
  Future<Stream<List<MessageModel>>> getMessagesStream({required String coreId});

  Future<List<MessageModel>> getMessagesList({required String coreId});

  Future<void> markMessagesAsReadById({required String lastReadmessageId, required String chatId});

  Future<void> markAllMessagesAsRead({required String chatId});
}
