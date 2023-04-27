import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/chats/data/models/chat_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/message_model.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model.dart';

import '../data/models/forward_massages_view_arguments_model..dart';

class ForwardMassagesController extends GetxController {
  //TODO: Implement ForwardMassagesController
  late ForwardMassagesArgumentsModel args;
  late TextEditingController inputController;
  RxBool isTextInputFocused = false.obs;
  late List<MessageModel> selectedMessages;
  UserModel? selectedUser;
  RxString selectedUserName = "".obs;

  final count = 0.obs;
  @override
  void onInit() {
    inputController = TextEditingController();
    args = Get.arguments as ForwardMassagesArgumentsModel;
    selectedMessages = args.selectedMessages;
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
      iconUrl: "https://raw.githubusercontent.com/Zunawe/identicons/HEAD/examples/poly.png",
      nickname: "Nickname",
      coreId: 'CB92...969A',
      chatModel: ChatModel(
        id: "1",
        coreId: "1",
        name: "Crapps Wallbanger",
        icon: "https://raw.githubusercontent.com/Zunawe/identicons/HEAD/examples/poly.png",
        lastMessage: "I'm still waiting for the reply. I'll let you know once they get back to me.",
        lastReadMessageId: "",
        timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 5)),
      ),
    ),
    UserModel(
      name: "Fancy Potato",
      walletAddress: 'CB21...C325',
      coreId: 'CB21...C325',
      iconUrl: "https://avatars.githubusercontent.com/u/6634136?v=4",
      isOnline: true,
      isVerified: true,
      chatModel: ChatModel(
        id: "2",
        coreId: "2",
        name: "Fancy Potato",
        icon: "https://avatars.githubusercontent.com/u/6634136?v=4",
        lastMessage: "I can arrange the meeting with her tomorrow if you're ok with that.",
        lastReadMessageId: "",
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 2, minutes: 5)),
        isOnline: true,
        isVerified: true,
        notificationCount: 4,
      ),
    ),
    UserModel(
      name: "manly Cupholder",
      walletAddress: 'CB42...324E',
      coreId: 'CB42...324E',
      iconUrl: "https://avatars.githubusercontent.com/u/9801359?v=4",
      isOnline: true,
      chatModel: ChatModel(
        id: "3",
        coreId: "3",
        name: "Manly Cupholder",
        icon: "https://avatars.githubusercontent.com/u/9801359?v=4",
        lastReadMessageId: "",
        lastMessage: "That's nice!",
        timestamp: DateTime.now().subtract(const Duration(days: 10, hours: 2, minutes: 5)),
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
    searchSuggestions.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    searchSuggestions.refresh();
  }

  void setSelectedUser(UserModel user) {
    selectedUser = user;
    selectedUserName.value = user.name;
  }

  void increment() => count.value++;
}
