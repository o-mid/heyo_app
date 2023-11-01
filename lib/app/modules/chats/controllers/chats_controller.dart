import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'package:heyo/app/modules/chats/data/models/chat_model.dart';
import 'package:heyo/app/modules/chats/data/repos/chat_history/chat_history_abstract_repo.dart';
import 'package:heyo/app/modules/chats/widgets/delete_all_chats_bottom_sheet.dart';
import 'package:heyo/app/modules/chats/widgets/delete_chat_dialog.dart';
import 'package:heyo/app/modules/messages/data/repo/messages_abstract_repo.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model/user_model.dart';
import 'package:heyo/app/modules/shared/data/repository/contact_repository.dart';
import 'package:heyo/app/modules/shared/utils/extensions/core_id.extension.dart';

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

  void init() async {
    chats.clear();
    chats.value = await chatHistoryRepo.getAllChats();

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

  listenToChatsStream() async {
    Stream<List<ChatModel>> chatsStream =
        await chatHistoryRepo.getChatsStream();
    _chatsStreamSubscription = chatsStream.listen((newChats) {
      List<ChatModel> chatModel = [];

      newChats.forEach((element) async {
        UserModel? userModel =
            await contactRepository.getContactById(element.id);
        var isContact = (userModel != null);
        if (isContact) {
          chatModel.add(element.copyWith(name: userModel.name));
        } else {
          chatModel.add(element.copyWith(name: element.id.shortenCoreId));
        }
      });

      chats.value = chatModel;
      chats.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      chats.refresh();
    });
  }

  Future deleteChat(ChatModel chat) async {
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
        for (var element in chats) {
          await messagesRepo.deleteAllMessages(element.id);
        }
        await chatHistoryRepo.deleteAllChats();

        chats.clear();
      },
    );
  }

// add a single mock chats to the chat history with the given duration
  addMockChats({Duration duration = const Duration(seconds: 5)}) async {
    List<ChatModel> mockchats = [
      ChatModel(
        id: '1',
        isOnline: false,
        icon: "",
        name: "John ",
        lastMessage: "",
        lastReadMessageId: "",
        timestamp: DateTime.now(),
      ),
      ChatModel(
        id: '2',
        isOnline: true,
        icon: "",
        name: "emmy",
        lastMessage: "",
        lastReadMessageId: "",
        timestamp: DateTime.now(),
      ),
      ChatModel(
        id: '3',
        isOnline: false,
        icon: "",
        name: "dow",
        lastMessage: "",
        lastReadMessageId: "",
        isVerified: true,
        timestamp: DateTime.now(),
      ),
      ChatModel(
        id: '4',
        isOnline: true,
        icon: "",
        name: "docs",
        lastMessage: "",
        lastReadMessageId: "",
        timestamp: DateTime.now(),
      ),
      ChatModel(
        id: '5',
        isOnline: false,
        icon: "",
        name: "joseef boran",
        lastMessage: "",
        lastReadMessageId: "",
        isVerified: true,
        timestamp: DateTime.now(),
      ),
    ];

    for (int i = 0; i < mockchats.length; i++) {
      await Future.delayed(duration, () {
        chatHistoryRepo.addChatToHistory(mockchats[i].copyWith(
            timestamp: DateTime.now(),
            lastMessage: "${DateTime.now()}",
            icon: "https://avatars.githubusercontent.com/u/664${i}336?v=4"));
      });
    }
  }
}
