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
    //_addMockData();
    init();
    super.onInit();
  }

  void init() async {
    chats.value = await chatHistoryRepo.getAllChats();
    _chatsStreamSubscription = (await chatHistoryRepo.getChatsStream()).listen((newChats) {
      for (int i = 0; i < chats.length; i++) {
        if (!newChats.any((chat) => chat.id == chats[i].id)) {
          chats.removeAt(i);
        }
      }

      // add new calls
      for (int i = 0; i < newChats.length; i++) {
        if (!chats.any((chat) => chat.id == newChats[i].id)) {
          chats.insert(i, newChats[i]);
          animatedListKey.currentState?.insertItem(i);
        }
      }

      // update calls to latest changes
      for (int i = 0; i < newChats.length; i++) {
        chats[i] = newChats[i];
      }
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
}
