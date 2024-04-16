import 'package:heyo/modules/features/chats/presentation/models/chat_model/chat_history_model.dart';

abstract class ChatHistoryRepo {
  Future<void> addChatToHistory(ChatHistoryModel chat);

  Future<List<ChatHistoryModel>> getAllChats();

  Future<ChatHistoryModel?> getChat(String chatId);

  Future<List<ChatHistoryModel>> getChatsFromUserId(String userId);

  Future<void> deleteAllChats();

  Future<void> deleteChat(String chatId);

  Future<Stream<List<ChatHistoryModel>>> getChatsStream();

  Future<void> updateChat(ChatHistoryModel chat);
}
