import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/utils/extensions/string.extension.dart';

import '../../new_chat/data/models/user_model.dart';
import '../../p2p_node/data/account/account_info.dart';
import '../../shared/data/repository/contact_repository.dart';
import 'filter_model.dart';
import 'package:heyo/app/modules/add_participate/controllers/model.dart';
import 'package:heyo/app/modules/add_participate/domain/search_user_use_case.dart';

class AddParticipateController extends GetxController {
  RxList<ParticipateItem> selectedUser = <ParticipateItem>[].obs;
  RxList<ParticipateItem> searchSuggestions = <ParticipateItem>[].obs;

  late TextEditingController inputController;
 /* final ContactRepository contactRepository;
  final AccountInfo accountInfo;*/
  final inputFocusNode = FocusNode();
  final inputText = "".obs;
  late StreamSubscription _contactsStreamSubscription;

 /* AddParticipateController({
    required this.contactRepository,
    required this.accountInfo,
  });*/
  final SearchUserUseCase searchUserUseCase;
  AddParticipateController({
    required this.searchUserUseCase
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
  void onClose() {
    inputController.dispose();
    _contactsStreamSubscription.cancel();
  }

  //TODO ali check
  final String profileLink = "https://heyo.core/m6ljkB4KJ";

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


  listenToContacts() async {
    inputController.addListener(() {
      inputText.value = inputController.text;
      searchUsers(inputController.text);
    });

    _contactsStreamSubscription =
        (await contactRepository.getContactsStream()).listen((newContacts) async{
      // remove the deleted contacts from the list

      if (inputText.value == "") {
        searchSuggestions.value = newContacts.map((e) => e.mapToParticipateItem()).toList();
      }else {
        List<UserModel> items= (await searchUserUseCase.execute(inputText.value));

          searchSuggestions.value = items.map((e) => e.mapToParticipateItem()).toList();
        refresh();
        searchSuggestions.refresh();
      }
    });

    super.onInit();
  }

  void searchUsers(String query) async {
    //TODO icon and chatmodel should be filled with correct data


   List<UserModel> items= (await searchUserUseCase.execute(query));

   searchSuggestions.value = items.map((e) => e.mapToParticipateItem()).toList();
   refresh();
   searchSuggestions.refresh();

   /*  List<UserModel> searchedItems =
        (await contactRepository.search(query)).toList();

    if (searchedItems.isEmpty) {
      String? currentUserCoreId = await accountInfo.getCoreId();
      if (query.isValidCoreId() && currentUserCoreId != query) {
        //its a new user
        //TODO update fields based on correct data
        searchSuggestions.value = [
          UserModel(
            name: 'unknown',
            iconUrl: profileLink,
            walletAddress: query,
            coreId: query,
          ).mapToParticipateItem()
        ];
      } else {
        searchSuggestions.value = [];
      }
    } else {
      searchSuggestions.value = searchedItems.map((e) => e.mapToParticipateItem()).toList();
      refresh();
    }

    searchSuggestions.refresh();*/
  }

  RxBool isTextInputFocused = false.obs;

  void addUser(UserModel user) {
    var existingIndex = selectedUser.indexWhere((u) => u.coreId == user.coreId);

    if (existingIndex != -1) {
      selectedUser.removeAt(existingIndex);
    } else {
      selectedUser.insert(0, user.mapToParticipateItem()); //It will add user to the top
    }
  }

  bool isSelected(UserModel user) {
    return selectedUser.any((u) => u.coreId == user.coreId);
  }
}
