import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/utils/extensions/string.extension.dart';

import '../../new_chat/data/models/new_chat_view_arguments_model.dart';
import '../../new_chat/data/models/user_model.dart';
import '../../p2p_node/data/account/account_info.dart';
import '../../shared/data/repository/contact_repository.dart';
import '../data/models/filter_model.dart';
import '../widgets/invite_bttom_sheet.dart';

class AddParticipateController extends GetxController {
  RxList<UserModel> selectedUser = <UserModel>[].obs;

  late TextEditingController inputController;
  final ContactRepository contactRepository;
  final AccountInfo accountInfo;
  final inputFocusNode = FocusNode();
  final inputText = "".obs;
  late StreamSubscription _contactsStreamSubscription;
  AddParticipateController({
    required this.contactRepository,
    required this.accountInfo,
  });

// in nearby users Tab after 3 seconds the refresh button will be visible
  //RxBool refreshBtnVisibility = false.obs;

  //void makeRefreshBtnVisible() {
  //  Future.delayed(const Duration(seconds: 3), () {
  //    refreshBtnVisibility.value = true;
  //  });
  //}

  @override
  Future<void> onInit() async {
    inputController = TextEditingController();
    await listenToContacts();
    super.onInit();
  }

  @override
  void onReady() {
    if (Get.arguments != null) {
      final args = Get.arguments as NewChatArgumentsModel;
      // if openInviteBottomSheet is set to true then this will
      //open the invite bottom sheet right after initializing

      if (args.openInviteBottomSheet) {
        // TODO: ADD correct profile Invite Links
        openInviteBottomSheet(profileLink: profileLink);
      }
    }
    super.onReady();
  }

  @override
  void onClose() {
    inputController.dispose();
    _contactsStreamSubscription.cancel();
  }

  final String profileLink = "https://heyo.core/m6ljkB4KJ";
// Mock data for the users
  final nearbyUsers = <UserModel>[
    UserModel(
      name: "Crapps Wallbanger",
      walletAddress: 'CB92...969A',
      coreId: 'CB92...969A',
      iconUrl:
          "https://raw.githubusercontent.com/Zunawe/identicons/HEAD/examples/poly.png",
      nickname: "Nickname",
    ),
    UserModel(
      name: "Fancy Potato",
      walletAddress: 'CB21...C325',
      coreId: 'CB21...C325',
      iconUrl: "https://avatars.githubusercontent.com/u/6634136?v=4",
      isOnline: true,
      isVerified: true,
    ),
    UserModel(
      name: "manly Cupholder",
      walletAddress: 'CB42...324E',
      coreId: 'CB42...324E',
      iconUrl: "https://avatars.githubusercontent.com/u/9801359?v=4",
      isOnline: true,
    ),
  ].obs;

// Mock filters for the users
  RxList<FilterModel> filters = [
    FilterModel(
      title: "Verified",
      isActive: false.obs,
    ),
    FilterModel(
      title: "Online",
      isActive: false.obs,
    ),
  ].obs;

  RxList<UserModel> searchSuggestions = <UserModel>[].obs;

  listenToContacts() async {
    inputController.addListener(() {
      inputText.value = inputController.text;
      searchUsers(inputController.text);
    });

    _contactsStreamSubscription =
        (await contactRepository.getContactsStream()).listen((newContacts) {
      // remove the deleted contacts from the list

      if (inputText.value == "") {
        searchSuggestions.value = newContacts;
      }
    });
    nearbyUsers.sort(
      (a, b) => a.name.toLowerCase().compareTo(
            b.name.toLowerCase(),
          ),
    );
    super.onInit();
  }

  void searchUsers(String query) async {
    //TODO icon and chatmodel should be filled with correct data
    List<UserModel> searchedItems =
        (await contactRepository.search(query)).toList();

    if (searchedItems.isEmpty) {
      String? currentUserCoreId = await accountInfo.getCoreId();
      if (query.isValidCoreId() && currentUserCoreId != query) {
        //its a new user
        //TODO update fields based on correct data
        searchSuggestions.value = [
          UserModel(
            name: 'unknown',
            iconUrl: (nearbyUsers..shuffle()).first.iconUrl,
            walletAddress: query,
            coreId: query,
          )
        ];
      } else {
        searchSuggestions.value = [];
      }
    } else {
      searchSuggestions.value = searchedItems;
      refresh();
    }

    searchSuggestions.refresh();
  }

  RxBool isTextInputFocused = false.obs;

  void addUser(UserModel user) {
    var existingIndex = selectedUser.indexWhere((u) => u.coreId == user.coreId);

    if (existingIndex != -1) {
      selectedUser.removeAt(existingIndex);
    } else {
      selectedUser.insert(0, user); //It will add user to the top
    }
  }

  bool isSelected(UserModel user) {
    return selectedUser.any((u) => u.coreId == user.coreId);
  }
}
