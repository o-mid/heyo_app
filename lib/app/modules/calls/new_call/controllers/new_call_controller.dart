import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/modules/features/contact/usecase/contact_listener_use_case.dart';
import 'package:heyo/modules/features/contact/usecase/get_contacts_use_case.dart';
import 'package:heyo/app/modules/new_chat/widgets/invite_bttom_sheet.dart';
import 'package:heyo/app/modules/shared/data/repository/account/account_repository.dart';
import 'package:heyo/app/modules/shared/utils/extensions/barcode.extension.dart';
import 'package:heyo/app/modules/shared/utils/extensions/core_id.extension.dart';
import 'package:heyo/app/modules/shared/utils/extensions/string.extension.dart';
import 'package:heyo/app/modules/shared/widgets/qr_scan_view.dart';
import 'package:heyo/generated/locales.g.dart';
import 'package:heyo/modules/features/contact/domain/models/contact_model/contact_model.dart';

class NewCallController extends GetxController {
  NewCallController({
    required this.contactListenerUseCase,
    required this.accountInfoRepo,
    required this.getContactUserUseCase,
  });

  final ContactListenerUseCase contactListenerUseCase;
  final AccountRepository accountInfoRepo;
  final GetContactsUseCase getContactUserUseCase;

  final inputText = ''.obs;

  RxList<ContactModel> contactList = <ContactModel>[].obs;
  RxList<ContactModel> searchItems = <ContactModel>[].obs;
  RxMap<String, List<ContactModel>> groupedContact = RxMap();
  late StreamSubscription<List<ContactModel>> _contactsStreamSubscription;

  @override
  Future<void> onInit() async {
    //TODO(AliAzim): getContact() will call twice on init
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
    contactList.value = [];
    searchItems.value = [];
    groupedContact.value = {};

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
        (await contactListenerUseCase.execute()).listen(_updateName);
  }

  Future<void> _updateName(List<ContactModel> newContacts) async {
    await getContact();
    await searchUsers(inputText.value);
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
          ContactModel(
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
