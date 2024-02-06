import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

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

import '../../shared/data/models/messaging_participant_model.dart';

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/models/chat_view_model/chat_view_model.dart';

class ChatsController extends GetxController {
  final ChatHistoryLocalAbstractRepo chatHistoryRepo;
  final MessagesAbstractRepo messagesRepo;
  final ContactRepository contactRepository;

  ChatsController({
    required this.chatHistoryRepo,
    required this.messagesRepo,
    required this.contactRepository,
  });

  final animatedListKey = GlobalKey<AnimatedListState>();
  late StreamSubscription _chatsStreamSubscription;
  final chats = <ChatViewModel>[].obs; // Use ChatViewModel instead of ChatModel

  @override
  void onInit() {
    init();
    super.onInit();
  }

  Future<void> init() async {
    chats.clear();
    var chatModels = await chatHistoryRepo.getAllChats();
    chats
      ..assignAll(chatModels.map((chatModel) => chatModel.toViewModel()).toList())
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    await listenToChatsStream();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    _chatsStreamSubscription.cancel();
    super.onClose();
  }

  Future<void> listenToChatsStream() async {
    final chatsStream = await chatHistoryRepo.getChatsStream();
    _chatsStreamSubscription = chatsStream.listen((newChats) {
      List<ChatViewModel> removed = [];
      List<ChatViewModel> added = [];

      for (final chatModel in newChats) {
        var chatViewModel = chatModel.toViewModel();
        if (!chats.any((element) => element.id == chatViewModel.id)) {
          added.add(chatViewModel);
        } else {
          int index = chats.indexWhere((element) => element.id == chatViewModel.id);
          chats[index] = chatViewModel;
        }
      }

      for (var i = chats.length - 1; i >= 0; i--) {
        final chatViewModel = chats[i];
        if (!newChats.any((newChatModel) => newChatModel.id == chatViewModel.id)) {
          removed.add(chatViewModel);
        }
      }

      if (onChatsUpdated != null) {
        onChatsUpdated!(removed, added);
      }
    });

    chats
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp))
      ..refresh();
  }

  // the callback to be called when chats are updated sent to the view
  void Function(List<ChatViewModel> removed, List<ChatViewModel> added)? onChatsUpdated;

  Future<void> deleteChat(String chatId) async {
    await chatHistoryRepo.deleteChat(chatId);
    await messagesRepo.deleteAllMessages(chatId);
  }

  Future<bool> showDeleteChatDialog(String chatId) async {
    await Get.dialog<bool>(
      DeleteChatDialog(
        deleteChat: () => deleteChat(chatId),
      ),
    );
    return false;
  }

  void showDeleteAllChatsBottomSheet() {
    openDeleteAllChatsBottomSheet(
      onDelete: () async {
        for (final element in chats) {
          await messagesRepo.deleteAllMessages(element.id);
        }
        await chatHistoryRepo.deleteAllChats();

        chats.clear();
      },
    );
  }

// // add a single mock chats to the chat history with the given duration
//   addMockChats({Duration duration = const Duration(seconds: 5)}) async {
//     var mockchats = <ChatModel>[
//       ChatModel(
//         id: '1',
//         name: "John ",
//         lastMessage: "",
//         lastReadMessageId: "",
//         timestamp: DateTime.now(),
//         participants: [
//           MessagingParticipantModel(
//             coreId: '1',
//             chatId: ChatIdGenerator.generate(),
//           ),
//         ],
//       ),
//       ChatModel(
//         id: '2',
//         name: "emmy",
//         lastMessage: "",
//         lastReadMessageId: "",
//         timestamp: DateTime.now(),
//         participants: [
//           MessagingParticipantModel(
//             coreId: '2',
//             chatId: ChatIdGenerator.generate(),
//           ),
//         ],
//       ),
//       ChatModel(
//         id: '3',
//         name: "dow",
//         lastMessage: "",
//         lastReadMessageId: "",
//         timestamp: DateTime.now(),
//         participants: [
//           MessagingParticipantModel(
//             coreId: '3',
//             chatId: ChatIdGenerator.generate(),
//           ),
//         ],
//       ),
//       ChatModel(
//         id: '4',
//         name: "docs",
//         lastMessage: "",
//         lastReadMessageId: "",
//         timestamp: DateTime.now(),
//         participants: [
//           MessagingParticipantModel(
//             coreId: '4',
//             chatId: ChatIdGenerator.generate(),
//           ),
//         ],
//       ),
//       ChatModel(
//         id: '5',
//         name: "joseef boran",
//         lastMessage: "",
//         lastReadMessageId: "",
//         timestamp: DateTime.now(),
//         participants: [
//           MessagingParticipantModel(
//             coreId: '5',
//             chatId: ChatIdGenerator.generate(),
//           ),
//         ],
//       ),
//     ];

//     for (int i = 0; i < mockchats.length; i++) {
//       await Future.delayed(duration, () {
//         chatHistoryRepo.addChatToHistory(mockchats[i].copyWith(
//             timestamp: DateTime.now(),
//             lastMessage: "${DateTime.now()}"
//                 " ${mockchats[i].name}"));
//       });
//     }
//   }
}
