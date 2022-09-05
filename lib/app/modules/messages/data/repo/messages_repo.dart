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
  Future<MessageModel?> deleteMessage({required String messageId, required String chatId}) {
    return messagesProvider.deleteMessage(messageId: messageId, chatId: chatId);
  }

  @override
  Future<List<MessageModel>> getMessages(String chatId) {
    return messagesProvider.getMessages(chatId);
  }

  @override
  Future<MessageModel?> updateMessage({required MessageModel message, required String chatId}) {
    return messagesProvider.updateMessage(message: message, chatId: chatId);
  }
}
