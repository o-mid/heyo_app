import 'package:heyo/app/modules/chats/data/models/chat_model.dart';

abstract class ChatHistoryLocalAbstractRepo {
  Future<void> addChatToHistory(ChatModel chat);

  Future<List<ChatModel>> getAllChats();

  Future<ChatModel?> getChat(String chatId);

  Future<List<ChatModel>> getChatsFromUserId(String userId);

  Future<void> deleteAllChats();

  Future<void> deleteChat(String chatId);

  Future<Stream<List<ChatModel>>> getChatsStream();

  Future<void> updateChat(ChatModel chat);
}
