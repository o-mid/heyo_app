import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/chats/data/models/chat_model.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model.dart';

import '../data/models/forward_massages_view_arguements_model..dart';

class ForwardMassagesController extends GetxController {
  //TODO: Implement ForwardMassagesController
  late ForwardMassagesArgumentsModel args;
  late TextEditingController inputController;
  RxBool isTextInputFocused = false.obs;
  final count = 0.obs;
  @override
  void onInit() {
    inputController = TextEditingController();
    args = Get.arguments as ForwardMassagesArgumentsModel;
    inputController.addListener(() {
      searchUsers(inputController.text);
    });
    users.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    searchUsers("");
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    inputController.dispose();
    super.onClose();
  }

  final users = <UserModel>[
    UserModel(
      name: "Crapps Wallbanger",
      walletAddress: 'CB92...969A',
      icon:
          "https://raw.githubusercontent.com/Zunawe/identicons/HEAD/examples/poly.png",
      Nickname: "Nickname",
      chatModel: ChatModel(
        name: "Crapps Wallbanger",
        icon:
            "https://raw.githubusercontent.com/Zunawe/identicons/HEAD/examples/poly.png",
        lastMessage:
            "I'm still waiting for the reply. I'll let you know once they get back to me.",
        timestamp: "15:45",
      ),
    ),
    UserModel(
      name: "Fancy Potato",
      walletAddress: 'CB21...C325',
      icon: "https://avatars.githubusercontent.com/u/6634136?v=4",
      isOnline: true,
      isVerified: true,
      chatModel: ChatModel(
        name: "Fancy Potato",
        icon: "https://avatars.githubusercontent.com/u/6634136?v=4",
        lastMessage:
            "I can arrange the meeting with her tomorrow if you're ok with that.",
        timestamp: "Yesterday",
        isOnline: true,
        isVerified: true,
        notificationCount: 4,
      ),
    ),
    UserModel(
      name: "manly Cupholder",
      walletAddress: 'CB42...324E',
      icon: "https://avatars.githubusercontent.com/u/9801359?v=4",
      isOnline: true,
      chatModel: ChatModel(
        name: "Manly Cupholder",
        icon: "https://avatars.githubusercontent.com/u/9801359?v=4",
        lastMessage: "That's nice!",
        timestamp: "15/01/2022",
        isOnline: true,
        notificationCount: 11,
      ),
    ),
  ].obs;
  RxList<UserModel> searchSuggestions = <UserModel>[].obs;
  void searchUsers(String query) {
    searchSuggestions.value = users.where((user) {
      String username = user.name.toLowerCase();
      String inputedQuery = query.toLowerCase();
      return username.contains(inputedQuery);
    }).toList();
    searchSuggestions
        .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    searchSuggestions.refresh();
  }

  void increment() => count.value++;
}
