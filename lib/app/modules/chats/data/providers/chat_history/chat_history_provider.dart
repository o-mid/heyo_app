import 'dart:async';

import 'package:heyo/app/modules/chats/data/models/chat_model.dart';

import 'package:heyo/app/modules/chats/data/providers/chat_history/chat_history_abstract_provider.dart';
import 'package:heyo/app/modules/shared/data/providers/database/app_database.dart';
import 'package:sembast/sembast.dart';

class ChatHistoryProvider implements ChatHistoryLocalAbstractProvider {
  final AppDatabaseProvider appDatabaseProvider;
  ChatHistoryProvider({required this.appDatabaseProvider});
  static const String chatHistoryStoreName = 'chat_history';

  final _store = intMapStoreFactory.store(chatHistoryStoreName);

  Future<Database> get _db async => await appDatabaseProvider.database;

  @override
  Future<void> insert(ChatModel chat) async {
    await _store.add(await _db, chat.toJson());
  }

  @override
  Future<void> deleteAll() async {
    await _store.delete(await _db);
  }

  @override
  Future<void> deleteChat(String chatId) async {
    await _store.delete(
      await _db,
      finder: Finder(
        filter: Filter.equals('id', chatId),
      ),
    );
  }

  @override
  Future<List<ChatModel>> getAllChats() async {
    final records = await _store.find(
      await _db,
      finder: Finder(sortOrders: [SortOrder('timestamp', false)]),
    );

    return records.map((e) => ChatModel.fromJson(e.value)).toList();
  }

  @override
  Future<ChatModel?> getChat(String chatId) async {
    final records = await _store.find(
      await _db,
      finder: Finder(filter: Filter.equals('id', chatId)),
    );

    if (records.isEmpty) {
      return null;
    }

    final chatJson = records.first.value;
    return ChatModel.fromJson(chatJson);
  }

  @override
  Future<void> updateChat(ChatModel chat) async {
    final records = await _store.find(
      await _db,
      finder: Finder(filter: Filter.equals('id', chat.id)),
    );

    if (records.isEmpty) {
      insert(chat);
    } else {
      await _store.update(
        await _db,
        chat.toJson(),
        finder: Finder(filter: Filter.equals('id', chat.id)),
      );
    }
  }

  @override
  Future<List<ChatModel>> getChatsFromUserId(String userId) async {
    final records = await _store.find(
      await _db,
      finder: Finder(
        sortOrders: [SortOrder('timestamp', false)],
        filter: Filter.equals(
          'walletAddress',
          userId,
        ),
      ),
    );

    return records.map((e) => ChatModel.fromJson(e.value)).toList();
  }

  @override
  Future<Stream<List<ChatModel>>> getChatsStream() async {
    final query = _store.query(
      finder: Finder(sortOrders: [SortOrder('timestamp', false)]),
    );

    return query.onSnapshots(await _db).transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          sink.add(data.map((e) => ChatModel.fromJson(e.value)).toList());
        },
      ),
    );
  }
}
