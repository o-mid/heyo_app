import 'package:heyo/app/modules/messages/data/models/messages/message_model.dart';

abstract class MessagesAbstractRepo {
  /// adds new message to chat with id of [chatId]
  Future<void> createMessage({required MessageModel message, required String chatId});

  /// returns messages of a certain chat with id of [chatId]
  Future<List<MessageModel>> getMessages(String chatId);

  /// updates message of a certain chat with id of [chatId] and returns it if the [message]
  /// exists, otherwise returns null
  Future<MessageModel?> updateMessage({required MessageModel message, required String chatId});

  /// deletes message from a certain chat with id of [chatId] and returns it if the [messageId]
  /// exists, otherwise returns null
  Future<MessageModel?> deleteMessage({required String messageId, required String chatId});

  /// deletes a list of messages from [chatId]
  Future<void> deleteMessages({required List<String> messageIds, required String chatId});

  /// deletes all messages from [chatId]
  Future<void> deleteAllMessages(String chatId);

  /// returns Stream of messages of a certain chat with id of [chatId]
  Future<Stream<List<MessageModel>>> getMessagesStream(String chatId);

  /// returns a message of a certain chat with id of [chatId] and returns it if the [messageId] is available
  Future<MessageModel?> getMessageById({required String messageId, required String chatId});

  /// returns unread messages of a certain chat with id of [chatId]
  Future<List<MessageModel?>> getUnReadMessages(String chatId);

  /// returns unread messages count of a certain chat with id of [chatId]
  Future<int> getUnReadMessagesCount(String chatId);

  /// update messages status before the specified last read message id to read
  Future<void> markMessagesAsRead({required String lastReadmessageId, required String chatId});

  /// update all messages status to read
  Future<void> markAllMessagesAsRead({required String chatId});

  Future<List<MessageModel?>> getUnsentMessages(String chatId);
  // get all the messages from a coreID and update the sender name
  Future<void> updateMessagesSenderName({
    required String chatId,
    required String coreId,
    required String newSenderName,
  });
}
