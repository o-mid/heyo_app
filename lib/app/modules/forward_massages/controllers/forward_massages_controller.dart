import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/data/models/messages/message_model.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model/user_model.dart';

import '../data/models/forward_massages_view_arguments_model.dart';

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
      nickname: "Nickname",
      coreId: 'CB92...969A',
    ),
    UserModel(
      name: "Fancy Potato",
      walletAddress: 'CB21...C325',
      coreId: 'CB21...C325',
      isOnline: true,
      isVerified: true,
    ),
    UserModel(
      name: "manly Cupholder",
      walletAddress: 'CB42...324E',
      coreId: 'CB42...324E',
      isOnline: true,
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

  void setSelectedUser(String userCoreId) {
    selectedUser = searchSuggestions.where((user) => user.coreId == userCoreId).first;

    selectedUserName.value = selectedUser!.name;
  }

  void increment() => count.value++;
}
