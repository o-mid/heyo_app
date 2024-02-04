import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:heyo/app/modules/calls/usecase/get_contact_user_use_case.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model/user_model.dart';
import 'package:heyo/app/modules/new_chat/widgets/invite_bttom_sheet.dart';
import 'package:heyo/app/modules/shared/data/repository/account/account_repository.dart';
import 'package:heyo/app/modules/shared/data/repository/contact_repository.dart';
import 'package:heyo/app/modules/shared/utils/extensions/barcode.extension.dart';
import 'package:heyo/app/modules/shared/utils/extensions/core_id.extension.dart';
import 'package:heyo/app/modules/shared/utils/extensions/string.extension.dart';
import 'package:heyo/app/modules/shared/widgets/qr_scan_view.dart';
import 'package:heyo/generated/locales.g.dart';

class NewCallController extends GetxController {
  NewCallController({
    required this.contactRepository,
    required this.accountInfoRepo,
    required this.getContactUserUseCase,
  });

  final ContactRepository contactRepository;
  final AccountRepository accountInfoRepo;
  final GetContactUserUseCase getContactUserUseCase;

  final inputText = ''.obs;

  RxList<UserModel> contactList = <UserModel>[].obs;
  RxList<UserModel> searchItems = <UserModel>[].obs;
  RxMap<String, List<UserModel>> groupedContact = RxMap();
  late StreamSubscription<List<UserModel>> _contactsStreamSubscription;

  @override
  Future<void> onInit() async {
    await getContact();
    unawaited(_listenToContactsToUpdateName());
    super.onInit();
  }

  @override
  void onClose() {
    _contactsStreamSubscription.cancel();
    super.onClose();
  }

  final profileLink = 'https://heyo.core/m6ljkB4KJ';

  Future<void> getContact() async {
    final contacts = await getContactUserUseCase.execute();

    contactList
      ..value = contacts
      //* Sort the The list alphabetically
      ..sort((a, b) => a.name.compareTo(b.name));

    searchItems.value = contactList;

    for (final contact in contactList) {
      final firstChar = contact.name[0].toUpperCase();
      if (!groupedContact.containsKey(firstChar)) {
        groupedContact[firstChar] = [];
      }
      groupedContact[firstChar]!.add(contact);
    }
    print(groupedContact);
  }

  Future<void> _listenToContactsToUpdateName() async {
    _contactsStreamSubscription =
        (await contactRepository.getContactsStream()).listen(_updateName);
  }

  Future<void> _updateName(List<UserModel> newContacts) async {
    //* First we should loop throw all contacts and update their names
    updateContactName(newContacts);

    //* Second we should loop throw all search result and update their names
    updateSearchResultName(newContacts);
  }

  void updateContactName(List<UserModel> newContacts) {
    final newContactList = <UserModel>[];
    for (final contact in contactList) {
      // Check if there is a matching contact for the participant
      final matchingContact = newContacts.firstWhereOrNull(
        (contact) => contact.coreId == contact.coreId,
      );

      newContactList.add(
        matchingContact != null
            ? contact.copyWith(name: matchingContact.name)
            : contact,
      );
    }
    contactList.value = newContactList;
  }

  void updateSearchResultName(List<UserModel> newContacts) {
    final newSearchList = <UserModel>[];
    for (final item in searchItems) {
      //* Check if there is a matching contact for the participant
      final matchingContact = newContacts.firstWhereOrNull(
        (contact) => contact.coreId == contact.coreId,
      );

      newSearchList.add(
        matchingContact != null
            ? item.copyWith(name: matchingContact.name)
            : item,
      );
    }
    searchItems.value = newSearchList;
  }

  Future<void> searchUsers(String query) async {
    inputText.value = query;
    if (query == '') {
      searchItems.value = contactList;
    } else {
      query.toLowerCase();

      searchItems.value = contactList
          .where((item) => item.name.toLowerCase().contains(query))
          .toList();

      if (searchItems.isEmpty) {
        await searchByCoreId(query);
      }
    }
  }

  RxBool isTextInputFocused = false.obs;

  void qrBottomSheet() {
    Get.bottomSheet(
      FractionallySizedBox(
        heightFactor: 1,
        child: QrScanView(
          title: LocaleKeys.NewCallPage_appBarTitle.tr,
          hasBackButton: true,
          onDetect: handleScannedValue,
          subtitle: '',
        ),
      ),
      isScrollControlled: true,
    );
  }

  void inviteBottomSheet() {
    openInviteBottomSheet(profileLink: profileLink);
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
      isTextInputFocused.value = true;
      // this will set the input field to the scanned value and serach for users
      inputText.value = coreId;
      await searchByCoreId(coreId);
    } catch (e) {
      return;
    }
  }

  Future<void> searchByCoreId(String coreId) async {
    final currentUserCoreId = await accountInfoRepo.getUserAddress();
    if (coreId.isValidCoreId() && currentUserCoreId != coreId) {
      //* The searched coreId is in contact list
      searchItems.value =
          contactList.where((item) => item.coreId.contains(coreId)).toList();
      //* If it's not empty the searched coreId is in contact list
      if (searchItems.isEmpty) {
        //* It's a new user
        searchItems.value = [
          UserModel(
            name: coreId.shortenCoreId,
            coreId: coreId,
            walletAddress: coreId,
          ),
        ];
      }
    } else {
      searchItems.value = [];
    }
  }
}
