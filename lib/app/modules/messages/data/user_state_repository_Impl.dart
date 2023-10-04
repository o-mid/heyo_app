import 'dart:async';

import 'package:heyo/app/modules/chats/data/models/chat_model.dart';
import 'package:heyo/app/modules/messages/data/repo/messages_abstract_repo.dart';
import 'package:heyo/app/modules/messages/domain/user_state_repository.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model.dart';
import 'package:heyo/app/modules/shared/utils/extensions/core_id.extension.dart';

import '../../chats/data/repos/chat_history/chat_history_abstract_repo.dart';
import '../../shared/data/repository/contact_repository.dart';
import '../domain/message_repository_models.dart';

class UserStateRepositoryImpl implements UserStateRepository {
  final ChatHistoryLocalAbstractRepo chatHistoryRepo;
  final ContactRepository contactRepository;
  final MessagesAbstractRepo messagesRepo;

  UserStateRepositoryImpl({
    required this.chatHistoryRepo,
    required this.contactRepository,
    required this.messagesRepo,
  });

  @override
  Future<UserModel> getUserContact({required UserInstance userInstance}) async {
    final String coreId = userInstance.coreId;
    final String? iconUrl = userInstance.iconUrl;
    // check if user is already in contact
    UserModel? createdUser = await contactRepository.getContactById(coreId);

    if (createdUser == null) {
      createdUser = UserModel(
        coreId: coreId,
        iconUrl: iconUrl ?? "https://avatars.githubusercontent.com/u/2345136?v=4",
        name: coreId.shortenCoreId,
        isOnline: true,
        isContact: false,
        walletAddress: coreId,
      );
      // adds the new user to the repo and update the UserModel
      await contactRepository.addContact(createdUser);
    }
    return createdUser;
  }

  @override
  Future<void> saveUserStates({
    required UserInstance userInstance,
    required UserStates userStates,
  }) async {
    // final String coreId = userInstance.coreId;

    // final String? iconUrl = userInstance.iconUrl;

    final String lastReadRemoteMessagesId = userStates.lastReadRemoteMessagesId;

    final String scrollPositionMessagesId = userStates.scrollPositionMessagesId;

    final String chatId = userStates.chatId;

    final DateTime lastMessageTimestamp = userStates.lastMessageTimestamp;

    final String lastMessagePreview = userStates.lastMessagePreview;

    final UserModel user = await getUserContact(userInstance: userInstance);
    // saves the last read message index in the user preferences repo
    // print("saving lastReadRemoteMessagesId.value: ${lastReadRemoteMessagesId}");
    // print("saving scrollPositionMessagesId.value: ${scrollPositionMessagesId}");
    int unReadMessagesCount = await messagesRepo.getUnReadMessagesCount(chatId);

    final ChatModel? chatModel = await chatHistoryRepo.getChat(chatId);

    if (chatModel == null) {
      ChatModel updatedChatModel = ChatModel(
        id: chatId,
        icon: user.iconUrl,
        name: user.name,
        lastReadMessageId: lastReadRemoteMessagesId,
        isOnline: true,
        scrollPosition: scrollPositionMessagesId,
        lastMessage: lastMessagePreview,
        notificationCount: unReadMessagesCount,
        timestamp: lastMessageTimestamp,
      );
      await chatHistoryRepo.updateChat(updatedChatModel);
    } else {
      await chatHistoryRepo.updateChat(
        chatModel.copyWith(
            icon: user.iconUrl,
            name: user.name,
            lastReadMessageId: lastReadRemoteMessagesId,
            isOnline: true,
            scrollPosition: scrollPositionMessagesId,
            lastMessage: lastMessagePreview,
            notificationCount: unReadMessagesCount),
      );
    }
  }

  @override
  Future<ChatModel?> getUserChatModel({required String chatId}) async {
    ChatModel? user = await chatHistoryRepo.getChat(chatId);
    return user;
  }
}
