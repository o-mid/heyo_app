import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:heyo/app/modules/add_participate/controllers/filter_model.dart';
import 'package:heyo/app/modules/add_participate/usecase/get_contact_user_use_case.dart';
import 'package:heyo/app/modules/add_participate/usecase/search_contact_user_use_case.dart';
import 'package:heyo/app/modules/calls/domain/call_repository.dart';
import 'package:heyo/app/modules/calls/domain/models.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model.dart';
import 'package:heyo/app/modules/add_participate/controllers/participate_item_model.dart';

class AddParticipateController extends GetxController {
  RxList<ParticipateItem> selectedUser = <ParticipateItem>[].obs;
  RxList<ParticipateItem> participateItems = <ParticipateItem>[].obs;
  RxList<ParticipateItem> searchItems = <ParticipateItem>[].obs;

  late TextEditingController inputController;
  final inputFocusNode = FocusNode();
  final inputText = "".obs;
  final String profileLink = "https://heyo.core/m6ljkB4KJ";

  final SearchContactUserUseCase searchContactUserUseCase;
  final GetContactUserUseCase getContactUserUseCase;
  final CallRepository callRepository;
  AddParticipateController({
    required this.searchContactUserUseCase,
    required this.getContactUserUseCase,
    required this.callRepository,
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
    //* Get the list of users who are in call
    List<CallStream> callStreams;
    try {
      callStreams = await callRepository.getCallStreams();
    } catch (e) {
      debugPrint(e.toString());
      callStreams = [];
    }

    //* Remove the users who are already in call
    for (var callStream in callStreams) {
      contacts.removeWhere(
        (contact) => contact.coreId == callStream.coreId,
      );
    }

    participateItems.value =
        contacts.map((e) => e.mapToParticipateItem()).toList();
    searchItems.value = participateItems;
  }

  void searchUsers(String query) async {
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

  void selectUser(ParticipateItem user) {
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

  void addUsersToCall() async {
    debugPrint("Add selected users to call");

    //* Add user to call repo
    for (var user in selectedUser) {
      callRepository.addMember(user.coreId);
    }
    //* Pop to call page
    Get.back();
  }
}
