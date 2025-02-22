import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/shared/data/models/all_participant_model/all_participant_model.dart';
import 'package:heyo/app/modules/shared/data/repository/account/account_repository.dart';
import 'package:heyo/app/modules/shared/utils/extensions/barcode.extension.dart';
import 'package:heyo/app/modules/shared/utils/extensions/core_id.extension.dart';
import 'package:heyo/app/modules/shared/utils/extensions/string.extension.dart';
import 'package:heyo/app/modules/shared/widgets/qr_scan_view.dart';
import 'package:heyo/generated/locales.g.dart';
import 'package:heyo/modules/call/domain/call_repository.dart';
import 'package:heyo/modules/call/domain/models.dart';
import 'package:heyo/modules/features/contact/domain/models/contact_model/contact_model.dart';
import 'package:heyo/modules/features/contact/usecase/get_contacts_use_case.dart';

class AddParticipateController extends GetxController {
  AddParticipateController({
    //required this.searchContactUserUseCase,
    required this.getContactsUserUseCase,
    required this.callRepository,
    required this.accountInfoRepo,
  });

  //final SearchContactUserUseCase searchContactUserUseCase;
  final GetContactsUseCase getContactsUserUseCase;
  final CallRepository callRepository;
  final AccountRepository accountInfoRepo;

  RxList<AllParticipantModel> selectedUser = <AllParticipantModel>[].obs;
  RxList<AllParticipantModel> participateItems = <AllParticipantModel>[].obs;
  RxMap<String, List<AllParticipantModel>> groupedParticipateItems = RxMap();
  RxList<AllParticipantModel> searchItems = <AllParticipantModel>[].obs;
  Rx<TextEditingController> inputController = TextEditingController().obs;

  //final inputText = ''.obs;
  final profileLink = 'https://heyo.core/m6ljkB4KJ';

  @override
  Future<void> onInit() async {
    await getContact();
    super.onInit();
  }

  //@override
  //void onClose() {
  //  inputController.value.dispose();
  //}

// Mock filters for the users
  //RxList<FilterModel> filters = [
  //  FilterModel(
  //    title: 'Verified',
  //    isActive: false.obs,
  //  ),
  //  FilterModel(
  //    title: 'Online',
  //    isActive: false.obs,
  //  ),
  //].obs;

  Future<void> getContact() async {
    final contacts = await getContactsUserUseCase.execute();
    //* Get the list of users who are in call
    var callStreams = <CallStream>[];
    try {
      (await callRepository.getCallStreams()).toList().forEach((element) {
        if (element.remoteStream != null) {
          callStreams.add(element);
        }
      });
    } catch (e) {
      debugPrint(e.toString());
      callStreams = [];
    }

    //* Remove the users who are already in call
    for (final callStream in callStreams) {
      contacts.removeWhere(
        (contact) => contact.coreId == callStream.coreId,
      );
    }

    participateItems
      ..value = contacts.map((e) => e.toAllParticipantModel()).toList()
      //* Sort the The list alphabetically
      ..sort((a, b) => a.name.compareTo(b.name));

    searchItems.value = participateItems;

    for (final participant in participateItems) {
      final firstChar = participant.name[0].toUpperCase();
      if (!groupedParticipateItems.containsKey(firstChar)) {
        groupedParticipateItems[firstChar] = [];
      }
      groupedParticipateItems[firstChar]!.add(participant);
    }
    print(groupedParticipateItems);
  }

  Future<void> searchUsers(String query) async {
    inputController.value.text = query;
    if (query == '') {
      searchItems.value = participateItems;
    } else {
      query.toLowerCase();

      searchItems.value = participateItems
          .where((item) => item.name.toLowerCase().contains(query))
          .toList();

      if (searchItems.isEmpty) {
        await searchByCoreId(query);
      }
    }
  }

  RxBool isTextInputFocused = false.obs;

  void selectUser(AllParticipantModel user) {
    final existingIndex =
        selectedUser.indexWhere((u) => u.coreId == user.coreId);

    if (existingIndex != -1) {
      selectedUser.removeAt(existingIndex);
    } else {
      //It will add user to the top
      selectedUser.insert(0, user);
    }
  }

  RxBool isSelected(AllParticipantModel user) {
    return selectedUser.any((u) => u.coreId == user.coreId).obs;
  }

  bool allSubgroupSelected(String firstChar) {
    var allSelected = false;
    var selectionCount = 0;
    final contactsForChar = groupedParticipateItems[firstChar]!;
    for (final user in contactsForChar) {
      if (isSelected(user).isTrue) {
        selectionCount++;
      }
    }

    //* This means all the subGroup are selected
    if (selectionCount == contactsForChar.length) {
      allSelected = true;
    }

    return allSelected;
  }

  void clearRxList() {
    selectedUser.clear();
    participateItems.clear();
    searchItems.clear();
  }

  Future<void> addUsersToCall() async {
    if (selectedUser.isEmpty) {
      return;
    }

    debugPrint('Add selected users to call');

    //* Pop to call page
    Get.back();

    //* Add user to call repo
    for (final user in selectedUser) {
      await callRepository.addMember(user.coreId);
    }

    //* Clears list
    clearRxList();
  }

  void qrBottomSheet() {
    Get.bottomSheet(
      FractionallySizedBox(
        heightFactor: 1,
        child: QrScanView(
          title: LocaleKeys.addParticipate_appbarTitle.tr,
          hasBackButton: true,
          onDetect: handleScannedValue,
          subtitle: '',
        ),
      ),
      isScrollControlled: true,
    );
  }

  Future<void> handleScannedValue(String? barcodeValue) async {
    // TODO: Implement the right filter logic for QRCode
    if (barcodeValue == null) {
      // Todo(qr)
      return;
    }
    try {
      final coreId = barcodeValue.getCoreId();

      Get.back();
      //isTextInputFocused.value = true;
      // this will set the input field to the scanned value and serach for users
      inputController.value.text = coreId;
      await searchByCoreId(coreId);
    } catch (e) {
      return;
    }
  }

  Future<void> searchByCoreId(String coreId) async {
    final currentUserCoreId = await accountInfoRepo.getUserAddress();
    if (coreId.isValidCoreId() && currentUserCoreId != coreId) {
      //* The searched coreId is in contact list
      searchItems.value = participateItems
          .where((item) => item.coreId.contains(coreId))
          .toList();
      //* If it's not empty the searched coreId is in contact list
      if (searchItems.isEmpty) {
        //* It's a new user
        searchItems.value = [
          AllParticipantModel(
            name: coreId.shortenCoreId,
            coreId: coreId,
          ),
        ];
      }
    } else {
      searchItems.value = [];
    }
  }
}
