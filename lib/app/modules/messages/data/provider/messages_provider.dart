import 'dart:async';

import 'package:heyo/app/modules/messages/data/models/messages/message_model.dart';
import 'package:heyo/app/modules/messages/data/provider/messages_abstract_provider.dart';
import 'package:heyo/app/modules/messages/utils/message_from_json.dart';
import 'package:heyo/app/modules/shared/providers/database/app_database.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/utils/value_utils.dart';

class MessagesProvider implements MessagesAbstractProvider {
  final AppDatabaseProvider appDatabaseProvider;
  MessagesProvider({required this.appDatabaseProvider});
  static const String messagesStoreName = 'messages';

  final _store = StoreRef<String, List<Object?>>(messagesStoreName);

  Future<Database> get _db async => await appDatabaseProvider.database;

  @override
  Future<void> createMessage({required MessageModel message, required String chatId}) async {
    var messages = await _store.record(chatId).get(await _db) ?? [];

    messages = cloneList(messages);

    messages.add(message.toJson());
    await _store.record(chatId).put(await _db, messages);
  }

  @override
  Future<List<MessageModel>> getMessages(String chatId) async {
    var messages = await _store.record(chatId).get(await _db) ?? [];
    messages = cloneList(messages);

    messages.removeWhere((element) => element == null);

    final nullableMessages =
        messages.map((m) => messageFromJson(m as Map<String, dynamic>)).toList();

    return nullableMessages.whereType<MessageModel>().toList()
      ..sort((a, b) => a.timestamp.millisecondsSinceEpoch - b.timestamp.millisecondsSinceEpoch);
  }

  @override
  Future<MessageModel?> updateMessage(
      {required MessageModel message, required String chatId}) async {
    final messages = await getMessages(chatId);
    final index = messages.indexWhere((m) => m.messageId == message.messageId);

    // message not found
    if (index < 0) {
      return null;
    }

    messages[index] = message;
    await _store.record(chatId).put(await _db, messages.map((m) => m.toJson()).toList());
    return message;
  }

  @override
  Future<MessageModel?> getMessageById({required String messageId, required String chatId}) async {
    final messages = await getMessages(chatId);
    final index = messages.indexWhere((m) => m.messageId == messageId);

    // message not found
    if (index < 0) {
      return null;
    }

    return messages[index];
  }

  @override
  Future<MessageModel?> deleteMessage({
    required String messageId,
    required String chatId,
  }) async {
    final messages = await getMessages(chatId);
    final index = messages.indexWhere((m) => m.messageId == messageId);

    // message not found
    if (index < 0) {
      return null;
    }

    final message = messages.removeAt(index);
    await _store.record(chatId).put(await _db, messages.map((m) => m.toJson()).toList());
    return message;
  }

  @override
  Future<void> deleteMessages({
    required List<String> messageIds,
    required String chatId,
  }) async {
    final messages = await getMessages(chatId);
    messages.removeWhere((m) => messageIds.contains(m.messageId));
    await _store.record(chatId).put(await _db, messages.map((m) => m.toJson()).toList());
  }

  @override
  Future<Stream<List<MessageModel>>> getMessagesStream(String chatId) async {
    return _store.record(chatId).onSnapshot(await _db).transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          var messages = data?.value ?? [];
          messages = cloneList(messages);

          messages.removeWhere((element) => element == null);

          final nullableMessages =
              messages.map((m) => messageFromJson(m as Map<String, dynamic>)).toList();

          sink.add(nullableMessages.whereType<MessageModel>().toList());
        },
      ),
    );
  }
}
