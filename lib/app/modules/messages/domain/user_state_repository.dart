import 'dart:async';
import 'package:heyo/app/modules/chats/data/models/chat_model.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model/user_model.dart';
import 'package:heyo/modules/features/contact/domain/models/contact_model/contact_model.dart';
import 'message_repository_models.dart';

abstract class UserStateRepository {
  Future<ContactModel> getUserContact({required UserInstance userInstance});

  Future<void> saveUserStates({
    required List<UserInstance> userInstances,
    required UserStates userStates,
  });

  Future<ChatModel?> getUserChatModel({required String chatId});
}
