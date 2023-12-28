import 'dart:async';
import '../data/models/messages/message_model.dart';

abstract class MessageRepository {
  Future<Stream<List<MessageModel>>> getMessagesStream({required String chatId});

  Future<List<MessageModel>> getMessagesList({required String chatId});

  Future<void> markMessagesAsReadById({required String lastReadmessageId, required String chatId});

  Future<void> markAllMessagesAsRead({required String chatId});
}
