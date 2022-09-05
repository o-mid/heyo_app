import 'package:heyo/app/modules/messages/data/models/messages/message_model.dart';
import 'package:heyo/app/modules/messages/data/provider/messages_abstract_provider.dart';
import 'package:heyo/app/modules/messages/utils/message_from_json.dart';
import 'package:heyo/app/modules/shared/providers/database/app_database.dart';
import 'package:sembast/sembast.dart';

class MessagesProvider implements MessagesAbstractProvider {
  final AppDatabaseProvider appDatabaseProvider;
  MessagesProvider({required this.appDatabaseProvider});
  static const String messagesStoreName = 'messages';

  final _store = StoreRef<String, List<Object?>>(messagesStoreName);

  Future<Database> get _db async => await appDatabaseProvider.database;

  @override
  Future<void> createMessage({required MessageModel message, required String chatId}) async {
    final messages = await _store.record(chatId).get(await _db) ?? [];

    messages.add(message.toJson());
    await _store.record(chatId).put(await _db, messages);
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
    await _store.record(chatId).put(await _db, messages);
    return message;
  }

  @override
  Future<List<MessageModel>> getMessages(String chatId) async {
    final messages = await _store.record(chatId).get(await _db) ?? [];
    messages.removeWhere((element) => element == null);

    final nullableMessages = messages
        .whereType<String>()
        .map((m) => messageFromJson(m as Map<String, dynamic>))
        .toList();

    return nullableMessages.whereType<MessageModel>().toList();
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
    await _store.record(chatId).put(await _db, messages);
    return message;
  }
}
