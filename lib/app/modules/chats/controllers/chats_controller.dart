import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:heyo/app/modules/chats/data/models/chat_model.dart';
import 'package:heyo/app/modules/chats/data/repos/chat_history/chat_history_abstract_repo.dart';
import 'package:heyo/app/modules/chats/widgets/chat_widget.dart';
import 'package:heyo/app/modules/chats/widgets/delete_all_chats_bottom_sheet.dart';
import 'package:heyo/app/modules/chats/widgets/delete_chat_dialog.dart';
import 'package:heyo/app/modules/messages/data/repo/messages_abstract_repo.dart';
import 'package:heyo/app/modules/messages/utils/chat_Id_generator.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model/user_model.dart';
import 'package:heyo/app/modules/shared/data/repository/contact_repository.dart';
import 'package:heyo/app/modules/shared/utils/extensions/core_id.extension.dart';

import '../../messages/data/provider/messages_provider.dart';
import '../../messages/data/repo/messages_repo.dart';
import '../../shared/data/models/messaging_participant_model.dart';

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../shared/data/providers/database/app_database.dart';
import '../data/models/chat_view_model/chat_view_model.dart';

final chatsControllerProvider =
    AutoDisposeAsyncNotifierProvider<ChatsController, List<ChatViewModel>>(
  () => ChatsController(
    chatHistoryRepo: Get.find<ChatHistoryLocalAbstractRepo>(),
    messagesRepo: MessagesRepo(
      messagesProvider: MessagesProvider(
        appDatabaseProvider: Get.find<AppDatabaseProvider>(),
      ),
    ),
    contactRepository: Get.find<ContactRepository>(),
  ),
);

class ChatsController extends AutoDisposeAsyncNotifier<List<ChatViewModel>> {
  final ChatHistoryLocalAbstractRepo chatHistoryRepo;
  final MessagesAbstractRepo messagesRepo;
  final ContactRepository contactRepository;

  List<ChatViewModel> chats = [];

  ChatsController({
    required this.chatHistoryRepo,
    required this.messagesRepo,
    required this.contactRepository,
  });

  @override
  FutureOr<List<ChatViewModel>> build() async {
    unawaited(_fetchInitialChats());
    await listenToChatsUpdates();
    return chats;
  }

  Future<void> _fetchInitialChats() async {
    final chats = await chatHistoryRepo.getAllChats();

    state = AsyncData(chats.map((chat) => chat.toViewModel()).toList());
  }

  Future<void> listenToChatsUpdates() async {
    final chatsStream = await chatHistoryRepo.getChatsStream();
    chatsStream.listen((newChats) {
      List<ChatViewModel> updatedChats = [];
      Map<String, ChatViewModel> updatedChatsMap = {};

      for (final chatModel in newChats) {
        var chatViewModel = chatModel.toViewModel();
        updatedChatsMap[chatViewModel.id] = chatViewModel;
      }

      // Check for removed chats
      chats.removeWhere((existingChat) => !updatedChatsMap.containsKey(existingChat.id));

      // Update existing chats or add new chats
      for (var chatId in updatedChatsMap.keys) {
        var existingChatIndex = chats.indexWhere((chat) => chat.id == chatId);
        if (existingChatIndex != -1) {
          chats[existingChatIndex] = updatedChatsMap[chatId]!;
        } else {
          chats.add(updatedChatsMap[chatId]!);
        }
      }

      // Sort chats by timestamp, newest first
      chats.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      state = AsyncData(chats);
    });
  }

  void showDeleteAllChatsBottomSheet() {
//     openDeleteAllChatsBottomSheet(
//       onDelete: () async {
//         for (final element in chats) {
//           await messagesRepo.deleteAllMessages(element.id);
//         }
//         await chatHistoryRepo.deleteAllChats();

//         chats.clear();
//       },
//     );

    Future<void> showDeleteAllChatsBottomSheet() async {}

    Future<void> deleteChat(String chatId) async {
      await chatHistoryRepo.deleteChat(chatId);
      await messagesRepo.deleteAllMessages(chatId);

      chats.removeWhere((chat) => chat.id == chatId);
    }
  }
}
