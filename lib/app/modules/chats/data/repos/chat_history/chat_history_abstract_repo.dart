import 'package:heyo/app/modules/chats/data/models/chat_model.dart';

abstract class ChatHistoryAbstractRepo {
  Future<void> addChatToHistory(ChatModel chat);

  Future<List<ChatModel>> getAllChats();

  Future<ChatModel?> getOneChat(String chatId);

  Future<List<ChatModel>> getChatsFromUserId(String userId);

  Future<void> deleteAllChats();

  Future<void> deleteOneChat(String chatId);

  Future<Stream<List<ChatModel>>> getChatsStream();
}
