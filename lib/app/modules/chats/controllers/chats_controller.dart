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

  final chats = <ChatModel>[].obs;

  @override
  void onInit() {
    init();
    super.onInit();
  }

  Future<void> init() async {
    chats.clear();
    //chats.value = await chatHistoryRepo.getAllChats();
    chats.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    await listenToChatsStream();

    // addMockChats();
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
    Stream<List<ChatModel>> chatsStream =
        await chatHistoryRepo.getChatsStream();
    _chatsStreamSubscription = chatsStream.listen((newChats) {
      List<ChatModel> removed = [];
      List<ChatModel> added = [];

      for (var chat in newChats) {
        // Find and animate added chats
        if (!chats.any((element) => element.id == chat.id)) {
          added.add(chat);
        } else {
          // Update existing chats
          int index = chats.indexWhere((element) => element.id == chat.id);
          chats[index] = chat;
        }
      }

      // Find and animate removed chats
      for (int i = chats.length - 1; i >= 0; i--) {
        final chat = chats[i];
        if (!newChats.any((newChat) => newChat.id == chat.id)) {
          removed.add(chat);
        }
      }
      if (onChatsUpdated != null) {
        onChatsUpdated!(removed, added);
      }
    });

    chats.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    chats.refresh();
  }

  // the callback to be called when chats are updated sent to the view
  void Function(List<ChatModel> removed, List<ChatModel> added)? onChatsUpdated;

  Future<void> deleteChat(ChatModel chat) async {
    await chatHistoryRepo.deleteChat(chat.id);
    await messagesRepo.deleteAllMessages(chat.id);
  }

  Future<bool> showDeleteChatDialog(ChatModel chat) async {
    await Get.dialog<bool>(
      DeleteChatDialog(
        deleteChat: () => deleteChat(chat),
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

// add a single mock chats to the chat history with the given duration
  addMockChats({Duration duration = const Duration(seconds: 5)}) async {
    var mockchats = <ChatModel>[
      ChatModel(
        id: '1',
        name: "John ",
        lastMessage: "",
        lastReadMessageId: "",
        timestamp: DateTime.now(),
        participants: [
          MessagingParticipantModel(
            coreId: '1',
            chatId: ChatIdGenerator.generate(),
          ),
        ],
      ),
      ChatModel(
        id: '2',
        name: "emmy",
        lastMessage: "",
        lastReadMessageId: "",
        timestamp: DateTime.now(),
        participants: [
          MessagingParticipantModel(
            coreId: '2',
            chatId: ChatIdGenerator.generate(),
          ),
        ],
      ),
      ChatModel(
        id: '3',
        name: "dow",
        lastMessage: "",
        lastReadMessageId: "",
        timestamp: DateTime.now(),
        participants: [
          MessagingParticipantModel(
            coreId: '3',
            chatId: ChatIdGenerator.generate(),
          ),
        ],
      ),
      ChatModel(
        id: '4',
        name: "docs",
        lastMessage: "",
        lastReadMessageId: "",
        timestamp: DateTime.now(),
        participants: [
          MessagingParticipantModel(
            coreId: '4',
            chatId: ChatIdGenerator.generate(),
          ),
        ],
      ),
      ChatModel(
        id: '5',
        name: "joseef boran",
        lastMessage: "",
        lastReadMessageId: "",
        timestamp: DateTime.now(),
        participants: [
          MessagingParticipantModel(
            coreId: '5',
            chatId: ChatIdGenerator.generate(),
          ),
        ],
      ),
    ];

    for (int i = 0; i < mockchats.length; i++) {
      await Future.delayed(duration, () {
        chatHistoryRepo.addChatToHistory(mockchats[i].copyWith(
            timestamp: DateTime.now(),
            lastMessage: "${DateTime.now()}"
                " ${mockchats[i].name}"));
      });
    }
  }
}
