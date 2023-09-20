import 'dart:async';

import '../../new_chat/data/models/user_model.dart';
import '../data/models/messages/message_model.dart';
import 'message_repository_models.dart';

abstract class MessageRepository {
  Future<UserModel> getUserContact({required UserInstance userInstance});

  Future<void> saveUserStates({required UserInstance userInstance, required UserStates userStates});

  Future<Stream<List<MessageModel>>> getMessagesStream({required String coreId});

  Future<List<MessageModel>> getMessagesList({required String coreId});
}
