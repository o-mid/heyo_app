import 'dart:async';
import 'dart:ffi';

import 'package:heyo/app/modules/messages/data/models/messages/message_model.dart';
import 'package:heyo/app/modules/messages/data/provider/messages_abstract_provider.dart';
import 'package:heyo/app/modules/messages/data/usecases/update_message_usecase.dart';
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

// store the messages in db with local timestamp (not utc) to avoid issues with timezones
    messages.add(message.copyWith(timestamp: message.timestamp.toLocal()).toJson());
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

  // returns Count of Messages where isFromMe is false and status is delivered (not read)
  @override
  Future<int> getUnReadMessagesCount(String chatId) async {
    final messages = await getMessages(chatId);
    return messages
        .where((element) => element.isFromMe == false && element.status == MessageStatus.delivered)
        .toList()
        .length;
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

// returns a list of Messages where isFromMe is false and status is delivered (not read)
  @override
  Future<List<MessageModel?>> getUnReadMessages(String chatId) async {
    final messages = await getMessages(chatId);
    return messages
        .where((element) => element.isFromMe == false && element.status == MessageStatus.delivered)
        .toList();
  }

// returns a list of Messages where isFromMe is false and status is delivered (not read)
  @override
  Future<List<MessageModel?>> getUnsentMessages(String chatId) async {
    final messages = await getMessages(chatId);
    return messages
        .where((element) =>
            element.isFromMe && element.status == MessageStatus.sending ||
            element.status == MessageStatus.failed)
        .toList();
  }

  Future<int> _getMessageIndexById({required String messageId, required String chatId}) async {
    final messages = await getMessages(chatId);
    final index = messages.indexWhere((m) => m.messageId == messageId);
    return index;
  }

  @override
  Future<void> markMessagesAsRead(
      {required String lastReadmessageId, required String chatId}) async {
    // gets the index of the last read message in the list

    int lastReadmessageIdIndex =
        await _getMessageIndexById(messageId: lastReadmessageId, chatId: chatId);

    // gets the list of all the messages that are currently unread
    List<MessageModel?> unReadMessages = await getUnReadMessages(chatId);

    if (unReadMessages.isNotEmpty) {
      // checks for each unread message in the list
      // if the index is before the last read message sets the status to read
      for (var element in unReadMessages) {
        if (await _getMessageIndexById(messageId: element!.messageId, chatId: chatId) <=
            lastReadmessageIdIndex) {
          // sets the status to read
          await updateMessage(
              message: element.copyWith(
                status: element.status.readStatus(),
              ),
              chatId: chatId);
        }
      }
    }
  }

  @override
  Future<void> markAllMessagesAsRead({required String chatId}) async {
    // gets the list of all the messages that are currently unread
    List<MessageModel?> unReadMessages = await getUnReadMessages(chatId);

    if (unReadMessages.isNotEmpty) {
      // checks for each unread message in the list
      // if the index is before the last read message sets the status to read
      for (var item in unReadMessages) {
        if (item != null) {
          // sets the status to read
          updateMessage(
              message: item.copyWith(
                status: item.status.readStatus(),
              ),
              chatId: chatId);
        }
      }
    }
  }

  @override
  Future<void> deleteAllMessages(String chatId) async {
    await _store.record(chatId).delete(await _db);
  }
}
