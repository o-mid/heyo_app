import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/chats/data/models/chat_model.dart';
import 'package:heyo/app/modules/chats/data/repos/chat_history/chat_history_abstract_repo.dart';

class ChatsController extends GetxController {
  final ChatHistoryLocalAbstractRepo chatHistoryRepo;
  ChatsController({required this.chatHistoryRepo});
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
    Stream<List<ChatModel>> chatsStream = await chatHistoryRepo.getChatsStream();
    _chatsStreamSubscription = chatsStream.listen((newChats) {
      chats.value = newChats;
      chats.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      chats.refresh();
    });
  }

// add a single mock chats to the chat history with the given duration
  addMockChats({Duration duration = const Duration(seconds: 5)}) async {
    List<ChatModel> mockchats = [
      ChatModel(
        id: '1',
        coreId: '1',
        isOnline: false,
        icon: "",
        name: "John ",
        lastMessage: "",
        lastReadMessageId: "",
        timestamp: DateTime.now(),
      ),
      ChatModel(
        id: '2',
        coreId: '2',
        isOnline: true,
        icon: "",
        name: "emmy",
        lastMessage: "",
        lastReadMessageId: "",
        timestamp: DateTime.now(),
      ),
      ChatModel(
        id: '3',
        coreId: '3',
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
        coreId: '4',
        isOnline: true,
        icon: "",
        name: "docs",
        lastMessage: "",
        lastReadMessageId: "",
        timestamp: DateTime.now(),
      ),
      ChatModel(
        id: '5',
        coreId: '5',
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
