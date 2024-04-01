import 'package:heyo/modules/features/chats/presentation/models/chat_model/chat_model.dart';

abstract class ChatHistoryRepo {
  Future<void> addChatToHistory(ChatModel chat);

  Future<List<ChatModel>> getAllChats();

  Future<ChatModel?> getChat(String chatId);

  Future<List<ChatModel>> getChatsFromUserId(String userId);

  Future<void> deleteAllChats();

  Future<void> deleteChat(String chatId);

  Future<Stream<List<ChatModel>>> getChatsStream();

  Future<void> updateChat(ChatModel chat);
}
