import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/add_participate/controllers/filter_model.dart';
import 'package:heyo/app/modules/add_participate/usecase/get_contact_user_use_case.dart';
import 'package:heyo/app/modules/add_participate/usecase/search_contact_user_use_case.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model.dart';
import 'package:heyo/app/modules/add_participate/controllers/participate_item_model.dart';

class AddParticipateController extends GetxController {
  RxList<ParticipateItem> selectedUser = <ParticipateItem>[].obs;
  RxList<ParticipateItem> participateItems = <ParticipateItem>[].obs;
  RxList<ParticipateItem> searchItems = <ParticipateItem>[].obs;

  late TextEditingController inputController;
  /* final ContactRepository contactRepository;
  final AccountInfo accountInfo;*/
  final inputFocusNode = FocusNode();
  final inputText = "".obs;
  //late StreamSubscription _contactsStreamSubscription;
  final String profileLink = "https://heyo.core/m6ljkB4KJ";

  final SearchContactUserUseCase searchContactUserUseCase;
  final GetContactUserUseCase getContactUserUseCase;
  AddParticipateController({
    required this.searchContactUserUseCase,
    required this.getContactUserUseCase,
  });

  @override
  Future<void> onInit() async {
    inputController = TextEditingController();
    getContact();
    super.onInit();
  }

  @override
  void onClose() {
    inputController.dispose();
    //_contactsStreamSubscription.cancel();
  }

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

  void getContact() async {
    List<UserModel> contacts = await getContactUserUseCase.execute();

    participateItems.value =
        contacts.map((e) => e.mapToParticipateItem()).toList();
    searchItems.value = participateItems;
  }

  //listenToContacts() async {
  //  inputController.addListener(() {
  //    inputText.value = inputController.text;
  //    searchUsers(inputController.text);
  //  });
  //  _contactsStreamSubscription = (await contactRepository.getContactsStream())
  //      .listen((newContacts) async {
  //    // remove the deleted contacts from the list
  //    if (inputText.value == "") {
  //      searchSuggestions.value =
  //          newContacts.map((e) => e.mapToParticipateItem()).toList();
  //    } else {
  //      List<UserModel> items =
  //          (await searchUserUseCase.execute(inputText.value));
  //      searchSuggestions.value =
  //          items.map((e) => e.mapToParticipateItem()).toList();
  //      refresh();
  //      searchSuggestions.refresh();
  //    }
  //  });
  //  super.onInit();
  //}

  void searchUsers(String query) async {
    //List<UserModel> items = (await searchContactUserUseCase.execute(query));

    //searchSuggestions.value =
    //    items.map((e) => e.mapToParticipateItem()).toList();
    //refresh();
    //searchSuggestions.refresh();
    if (query == "") {
      searchItems.value = participateItems;
    } else {
      query = query.toLowerCase();

      searchItems.value = participateItems
          .where((item) => item.name.toLowerCase().contains(query))
          .toList();
    }
    //refresh();
  }

  RxBool isTextInputFocused = false.obs;

  void addUser(ParticipateItem user) {
    var existingIndex = selectedUser.indexWhere((u) => u.coreId == user.coreId);

    if (existingIndex != -1) {
      selectedUser.removeAt(existingIndex);
    } else {
      //It will add user to the top
      selectedUser.insert(0, user);
    }
  }

  bool isSelected(ParticipateItem user) {
    return selectedUser.any((u) => u.coreId == user.coreId);
  }
}
