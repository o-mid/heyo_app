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
    Stream<List<ChatModel>> chatsStream = await chatHistoryRepo.getChatsStream();
    addMockChats();
    _chatsStreamSubscription = chatsStream.listen((newChats) {
      chats.value = newChats;
      chats.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      chats.refresh();
    });
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

  addMockChats() async {
    List<ChatModel> mockchats = [
      ChatModel(
        id: '1',
        isOnline: false,
        icon: "",
        name: "John ",
        lastMessage: "",
        timestamp: DateTime.now(),
      ),
      ChatModel(
        id: '2',
        isOnline: true,
        icon: "",
        name: "emmy",
        lastMessage: "",
        timestamp: DateTime.now(),
      ),
      ChatModel(
        id: '3',
        isOnline: false,
        icon: "",
        name: "dow",
        lastMessage: "",
        isVerified: true,
        timestamp: DateTime.now(),
      ),
      ChatModel(
        id: '4',
        isOnline: true,
        icon: "",
        name: "docs",
        lastMessage: "",
        timestamp: DateTime.now(),
      ),
      ChatModel(
        id: '5',
        isOnline: false,
        icon: "",
        name: "joseef boran",
        lastMessage: "",
        isVerified: true,
        timestamp: DateTime.now(),
      ),
    ];

    for (int i = 0; i < mockchats.length; i++) {
      await Future.delayed(const Duration(seconds: 6), () {
        chatHistoryRepo.addChatToHistory(mockchats[i].copyWith(
            timestamp: DateTime(2022, i, i),
            lastMessage: "${DateTime.now()}",
            icon: "https://avatars.githubusercontent.com/u/664${i}336?v=4"));
      });
    }
  }
}
