import 'package:heyo/app/modules/messages/data/models/messages/message_model.dart';

abstract class MessagesAbstractProvider {
  Future<void> createMessage({required MessageModel message, required String chatId});

  Future<List<MessageModel>> getMessages(String chatId);

  Future<Stream<List<MessageModel>>> getMessagesStream(String chatId);

  Future<MessageModel?> updateMessage({required MessageModel message, required String chatId});

  Future<MessageModel?> deleteMessage({required String messageId, required String chatId});

  Future<void> deleteMessages({required List<String> messageIds, required String chatId});

  Future<MessageModel?> getMessageById({required String messageId, required String chatId});

  Future<List<MessageModel?>> getUnReadMessages(String chatId);

  Future<int> getUnReadMessagesCount(String chatId);

  Future<void> markMessagesAsRead({required String lastReadmessageId, required String chatId});

  Future<void> markAllMessagesAsRead({required String chatId});
}
