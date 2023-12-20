import 'dart:async';

import 'package:heyo/app/modules/chats/data/models/chat_model.dart';

import '../../new_chat/data/models/user_model.dart';
import 'message_repository_models.dart';

abstract class UserStateRepository {
  Future<UserModel> getUserContact({required UserInstance userInstance});

  Future<void> saveUserStates({
    required List<UserInstance> userInstances,
    required UserStates userStates,
  });

  Future<ChatModel?> getUserChatModel({required String chatId});
}
