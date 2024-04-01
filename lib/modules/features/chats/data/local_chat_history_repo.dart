import 'package:heyo/modules/domain/chat_history/chat_history_abstract_provider.dart';
import 'package:heyo/modules/features/chats/presentation/models/chat_model/chat_model.dart';
import 'package:heyo/modules/features/chats/domain/chat_history_repo.dart';

class LocalChatHistoryRepo implements ChatHistoryRepo {
  final ChatHistoryLocalAbstractProvider chatHistoryProvider;

  LocalChatHistoryRepo({required this.chatHistoryProvider});

  @override
  Future<void> addChatToHistory(ChatModel chat) async {
    await chatHistoryProvider.insert(chat);
  }

  @override
  Future<List<ChatModel>> getAllChats() {
    return chatHistoryProvider.getAllChats();
  }

  @override
  Future<ChatModel?> getChat(String chatId) {
    return chatHistoryProvider.getChat(chatId);
  }

  @override
  Future<void> deleteAllChats() async {
    await chatHistoryProvider.deleteAll();
  }

  @override
  Future<void> deleteChat(String chatId) async {
    await chatHistoryProvider.deleteChat(chatId);
  }

  @override
  Future<List<ChatModel>> getChatsFromUserId(String userId) {
    return chatHistoryProvider.getChatsFromUserId(userId);
  }

  @override
  Future<Stream<List<ChatModel>>> getChatsStream() {
    return chatHistoryProvider.getChatsStream();
  }

  @override
  Future<void> updateChat(ChatModel chat) async {
    await chatHistoryProvider.updateChat(chat);
  }
}
