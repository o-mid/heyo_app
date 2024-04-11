import 'dart:async';

import 'package:heyo/app/modules/shared/data/providers/database/app_database.dart';
import 'package:heyo/modules/features/chats/data/chat_history_dto/chat_history_dto.dart';
import 'package:heyo/modules/features/chats/domain/chat_history_repo.dart';
import 'package:heyo/modules/features/chats/presentation/models/chat_model/chat_model.dart';
import 'package:sembast/sembast.dart';

class LocalChatHistoryRepo implements ChatHistoryRepo {
  LocalChatHistoryRepo({required this.appDatabaseProvider});
  final AppDatabaseProvider appDatabaseProvider;
  static const String chatHistoryStoreName = 'chat_history';

  final _store = intMapStoreFactory.store(chatHistoryStoreName);

  Future<Database> get _db async => await appDatabaseProvider.database;

  @override
  Future<void> addChatToHistory(ChatModel chat) async {
    final chatDTO = chat.toChatHistoryDTO();
    await _store.add(await _db, chatDTO.toJson());
  }

  @override
  Future<void> deleteAllChats() async {
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

    final chats = records.map(
      (e) {
        // Convert RecordSnapshot to ContactDTO
        final chatDTO = ChatHistoryDTO.fromJson(e.value);
        // Convert ContactDTO to ContactModel
        return chatDTO.toChatModel();
      },
    ).toList();
    return chats;
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
    final chatDTO = chat.toChatHistoryDTO();
    final records = await _store.find(
      await _db,
      finder: Finder(filter: Filter.equals('id', chatDTO.id)),
    );

    if (records.isEmpty) {
      await addChatToHistory(chatDTO.toChatModel());
    } else {
      await _store.update(
        await _db,
        chatDTO.toJson(),
        finder: Finder(filter: Filter.equals('id', chatDTO.id)),
      );
    }
  }

  @override
  Future<List<ChatModel>> getChatsFromUserId(String userId) async {
    final records = await _store.find(
      await _db,
      finder: Finder(
        sortOrders: [SortOrder('timestamp', false)],
      ),
    );

    final List<ChatHistoryDTO> chatsDTOs = [];

    for (var record in records) {
      final chatJson = record.value;
      final chatHistoryDTO = ChatHistoryDTO.fromJson(chatJson);

      for (final participant in chatHistoryDTO.participants) {
        if (participant.coreId == userId) {
          chatsDTOs.add(chatHistoryDTO);
          break;
        }
      }
    }
    final chats = chatsDTOs.map(
      (e) {
        return e.toChatModel();
      },
    ).toList();

    return chats;
  }

  @override
  Future<Stream<List<ChatModel>>> getChatsStream() async {
    final query = _store.query(
      finder: Finder(sortOrders: [SortOrder('timestamp', false)]),
    );

    return query.onSnapshots(await _db).transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          sink.add(
            data.map(
              (e) {
                final chatDTO = ChatHistoryDTO.fromJson(
                  e.value,
                );
                return chatDTO.toChatModel();
              },
            ).toList(),
          );
        },
      ),
    );
  }
}
