import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/chats/data/models/chat_model.dart';
import 'package:heyo/app/modules/chats/data/repos/chat_history/chat_history_abstract_repo.dart';

class ChatsController extends GetxController {
  final ChatHistoryAbstractRepo chatHistoryRepo;
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

  void _addMockData() {
    var index = 0;
    final mockChats = [
      ChatModel(
        id: "${index++}",
        name: "Crapps Wallbanger",
        icon: "https://raw.githubusercontent.com/Zunawe/identicons/HEAD/examples/poly.png",
        lastMessage: "I'm still waiting for the reply. I'll let you know once they get back to me.",
        timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 5)),
      ),
      ChatModel(
        id: "${index++}",
        name: "Fancy Potato",
        icon: "https://avatars.githubusercontent.com/u/6634136?v=4",
        lastMessage: "I can arrange the meeting with her tomorrow if you're ok with that.",
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 2, minutes: 5)),
        isOnline: true,
        isVerified: true,
        notificationCount: 4,
      ),
      ChatModel(
        id: "${index++}",
        name: "Manly Cupholder",
        icon: "https://avatars.githubusercontent.com/u/9801359?v=4",
        lastMessage: "That's nice!",
        timestamp: DateTime.now().subtract(const Duration(days: 10, hours: 2, minutes: 5)),
        isOnline: true,
        notificationCount: 11,
      ),
    ];
    for (var chat in mockChats) {
      chatHistoryRepo.addChatToHistory(chat);
    }
  }
}
