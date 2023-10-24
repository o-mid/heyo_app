import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:heyo/app/modules/messaging/usecases/handle_received_binary_data_usecase.dart';
import 'package:heyo/app/modules/messaging/utils/binary_file_receiving_state.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/mocks/random_avatar_icon.dart';

import '../../chats/data/models/chat_model.dart';
import '../../chats/data/repos/chat_history/chat_history_abstract_repo.dart';
import '../../messages/data/repo/messages_repo.dart';
import '../../new_chat/data/models/user_model.dart';
import '../../notifications/controllers/notifications_controller.dart';
import '../../shared/data/repository/contact_repository.dart';

class DataHandler {
  final MessagesRepo messagesRepo;
  final ChatHistoryLocalAbstractRepo chatHistoryRepo;
  final NotificationsController notificationsController;
  final ContactRepository contactRepository;

  DataHandler({
    required this.messagesRepo,
    required this.chatHistoryRepo,
    required this.notificationsController,
    required this.contactRepository,
  });

  createUserChatModel({required String sessioncid}) async {
    UserModel? userModel = await contactRepository.getContactById(sessioncid);

    final userChatModel = ChatModel(
      id: sessioncid,
      isOnline: true,
      name: (userModel == null)
          ? "${sessioncid.characters.take(4).string}...${sessioncid.characters.takeLast(4).string}"
          : userModel.name,
      icon: getMockIconUrl(),
      lastMessage: "",
      lastReadMessageId: "",
      isVerified: true,
      timestamp: DateTime.now(),
    );
    final currentChatModel = await chatHistoryRepo.getChat(userChatModel.id);

    if (currentChatModel == null) {
      await chatHistoryRepo.addChatToHistory(userChatModel);
    } else {
      /*   await chatHistoryRepo.updateChat(userChatModel.copyWith(
        lastMessage: currentChatModel.lastMessage,
        lastReadMessageId: currentChatModel.lastReadMessageId,
        notificationCount: currentChatModel.notificationCount,
        isOnline: true,
      ));*/
    }
  }

  Future<void> handleReceivedBinaryData({
    required String remoteCoreId,
    required BinaryFileReceivingState currentWebrtcBinaryState,
  }) async {
    await HandleReceivedBinaryData(messagesRepo: messagesRepo, chatId: remoteCoreId)
        .execute(state: currentWebrtcBinaryState, remoteCoreId: remoteCoreId);
  }
}
