import 'dart:async';

import 'package:heyo/app/modules/chats/data/models/chat_model.dart';
import 'package:heyo/app/modules/messages/data/repo/messages_abstract_repo.dart';
import 'package:heyo/app/modules/messages/domain/user_state_repository.dart';

import 'package:heyo/app/modules/shared/data/models/messaging_participant_model.dart';
import 'package:heyo/app/modules/shared/data/repository/account/account_repository.dart';
import 'package:heyo/app/modules/shared/utils/extensions/core_id.extension.dart';

import '../../chats/data/repos/chat_history/chat_history_abstract_repo.dart';
import '../../new_chat/data/models/user_model/user_model.dart';
import '../../../../modules/features/contact/data/local_contact_repo.dart';
import '../domain/message_repository_models.dart';

class UserStateRepositoryImpl implements UserStateRepository {
  final ChatHistoryLocalAbstractRepo chatHistoryRepo;
  final LocalContactRepo contactRepository;
  final MessagesAbstractRepo messagesRepo;
  final AccountRepository accountInfo;

  UserStateRepositoryImpl(
      {required this.chatHistoryRepo,
      required this.contactRepository,
      required this.messagesRepo,
      required this.accountInfo});

  @override
  Future<UserModel> getUserContact({required UserInstance userInstance}) async {
    final String coreId = userInstance.coreId;

    // check if user is already in contact
    UserModel? createdUser = await contactRepository.getContactById(coreId);

    if (createdUser == null) {
      createdUser = UserModel(
        coreId: coreId,
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
    required List<UserInstance> userInstances,
    required UserStates userStates,
  }) async {
    // final String coreId = userInstance.coreId;

    // final String? iconUrl = userInstance.iconUrl;

    final String chatName = userStates.chatName;

    final String lastReadRemoteMessagesId = userStates.lastReadRemoteMessagesId;

    final String scrollPositionMessagesId = userStates.scrollPositionMessagesId;

    final String chatId = userStates.chatId;

    final DateTime lastMessageTimestamp = userStates.lastMessageTimestamp;

    final String lastMessagePreview = userStates.lastMessagePreview;

    List<MessagingParticipantModel> participants = [];
    final List<UserModel> users = [];

    final selfCoreID = await accountInfo.getUserAddress();

    for (final element in userInstances) {
      if (element.coreId != selfCoreID) {
        users.add(await getUserContact(userInstance: element));
      }
      final user = await contactRepository.getContactById(element.coreId);

      participants.add(
        MessagingParticipantModel(
          coreId: element.coreId,
          chatId: userStates.chatId,
          name: user?.name,
        ),
      );
    }

    // final UserModel user = await getUserContact(userInstance: userInstance);
    // saves the last read message index in the user preferences repo
    // print("saving lastReadRemoteMessagesId.value: ${lastReadRemoteMessagesId}");
    // print("saving scrollPositionMessagesId.value: ${scrollPositionMessagesId}");
    int unReadMessagesCount = await messagesRepo.getUnReadMessagesCount(chatId);

    final ChatModel? chatModel = await chatHistoryRepo.getChat(chatId);

    final bool isGroupChat = users.length > 1;

    if (chatModel == null) {
      final updatedChatModel = ChatModel(
        id: chatId,
        name: chatName,
        lastReadMessageId: lastReadRemoteMessagesId,
        scrollPosition: scrollPositionMessagesId,
        lastMessage: lastMessagePreview,
        notificationCount: unReadMessagesCount,
        timestamp: lastMessageTimestamp,
        participants: participants,
      );
      await chatHistoryRepo.addChatToHistory(updatedChatModel);
    } else {
      await chatHistoryRepo.updateChat(
        chatModel.copyWith(
          id: chatId,
          name: isGroupChat ? chatName : chatModel.name,
          lastReadMessageId: lastReadRemoteMessagesId,
          scrollPosition: scrollPositionMessagesId,
          lastMessage: lastMessagePreview,
          notificationCount: unReadMessagesCount,
          timestamp: lastMessageTimestamp,
          participants: participants,
        ),
      );
    }
  }

  @override
  Future<ChatModel?> getUserChatModel({required String chatId}) async {
    ChatModel? user = await chatHistoryRepo.getChat(chatId);
    return user;
  }
}
