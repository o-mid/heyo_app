import 'package:heyo/app/modules/chats/data/models/chat_model.dart';
import 'package:heyo/app/modules/chats/data/repos/chat_history/chat_history_abstract_repo.dart';

import '../../providers/chat_history/chat_history_abstract_provider.dart';

class ChatHistoryLocalRepo implements ChatHistoryLocalAbstractRepo {
  final ChatHistoryLocalAbstractProvider chatHistoryProvider;

  ChatHistoryLocalRepo({required this.chatHistoryProvider});

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
