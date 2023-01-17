import '../../models/chat_model.dart';

abstract class ChatHistoryLocalAbstractProvider {
  Future<void> insert(ChatModel chat);

  Future<List<ChatModel>> getAllChats();

  Future<List<ChatModel>> getChatsFromUserId(String userId);

  Future<void> deleteAll();

  Future<void> deleteChat(String chatId);

  Future<ChatModel?> getChat(String chatId);

  Future<Stream<List<ChatModel>>> getChatsStream();

  Future<void> updateChat(ChatModel chat);
}
