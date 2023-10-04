import 'dart:async';

import 'package:heyo/app/modules/chats/data/models/chat_model.dart';

import '../../new_chat/data/models/user_model.dart';
import '../data/models/messages/message_model.dart';
import 'message_repository_models.dart';

abstract class ConnectionMessageRepository {
  Future<UserModel> getUserContact({required UserInstance userInstance});

  Future<void> saveUserStates({required UserInstance userInstance, required UserStates userStates});

  Future<Stream<List<MessageModel>>> getMessagesStream({required String coreId});

  Future<List<MessageModel>> getMessagesList({required String coreId});

  Future<void> markMessagesAsReadById({required String lastReadmessageId, required String chatId});

  Future<void> markAllMessagesAsRead({required String chatId});

  Future<ChatModel?> getUserChatModel({required String chatId});
}
