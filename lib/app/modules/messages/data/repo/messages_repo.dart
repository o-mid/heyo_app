import 'package:heyo/app/modules/messages/data/models/messages/message_model.dart';
import 'package:heyo/app/modules/messages/data/provider/messages_abstract_provider.dart';
import 'package:heyo/app/modules/messages/data/repo/messages_abstract_repo.dart';

class MessagesRepo implements MessagesAbstractRepo {
  final MessagesAbstractProvider messagesProvider;

  MessagesRepo({required this.messagesProvider});

  @override
  Future<void> createMessage({required MessageModel message, required String chatId}) {
    return messagesProvider.createMessage(message: message, chatId: chatId);
  }

  @override
  Future<List<MessageModel>> getMessages(String chatId) {
    return messagesProvider.getMessages(chatId);
  }

  @override
  Future<MessageModel?> updateMessage({required MessageModel message, required String chatId}) {
    return messagesProvider.updateMessage(message: message, chatId: chatId);
  }

  @override
  Future<MessageModel?> deleteMessage({required String messageId, required String chatId}) {
    return messagesProvider.deleteMessage(messageId: messageId, chatId: chatId);
  }

  @override
  Future<void> deleteMessages({required List<String> messageIds, required String chatId}) {
    return messagesProvider.deleteMessages(messageIds: messageIds, chatId: chatId);
  }

  @override
  Future<Stream<List<MessageModel>>> getMessagesStream(String chatId) {
    return messagesProvider.getMessagesStream(chatId);
  }

  @override
  Future<MessageModel?> getMessageById({required String messageId, required String chatId}) {
    return messagesProvider.getMessageById(messageId: messageId, chatId: chatId);
  }

  @override
  Future<List<MessageModel?>> getUnReadMessages(String chatId) {
    return messagesProvider.getUnReadMessages(chatId);
  }

  @override
  Future<int> getUnReadMessagesCount(String chatId) {
    return messagesProvider.getUnReadMessagesCount(chatId);
  }

  @override
  Future<void> markMessagesAsRead({required String lastReadmessageId, required String chatId}) {
    return messagesProvider.markMessagesAsRead(
        lastReadmessageId: lastReadmessageId, chatId: chatId);
  }

  @override
  Future<void> markAllMessagesAsRead({required String chatId}) {
    return messagesProvider.markAllMessagesAsRead(chatId: chatId);
  }

  @override
  Future<List<MessageModel?>> getUnsentMessages(String chatId) {
    return messagesProvider.getUnsentMessages(chatId);
  }
}
