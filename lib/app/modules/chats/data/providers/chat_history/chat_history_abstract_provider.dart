import '../../models/chat_model.dart';

abstract class ChatHistoryAbstractProvider {
  Future<void> insert(ChatModel chat);

  Future<List<ChatModel>> getAllChats();

  Future<List<ChatModel>> getChatsFromUserId(String userId);

  Future<void> deleteAll();

  Future<void> deleteOne(String chatId);

  Future<ChatModel?> getOneChat(String chatId);

  Future<Stream<List<ChatModel>>> getChatsStream();
}
