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
}
