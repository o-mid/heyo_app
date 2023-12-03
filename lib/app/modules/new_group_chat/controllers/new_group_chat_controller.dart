import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/utils/extensions/barcode.extension.dart';
import 'package:heyo/app/modules/shared/utils/extensions/string.extension.dart';

import '../../new_chat/data/models/user_model.dart';
import '../../shared/data/repository/contact_repository.dart';
import '../../shared/data/repository/crypto_account/account_repository.dart';

class NewGroupChatController extends GetxController {
  final ContactRepository contactRepository;
  final AccountRepository accountInfoRepo;
  final inputFocusNode = FocusNode();
  final inputText = "".obs;
  late StreamSubscription _contactasStreamSubscription;
  late TextEditingController inputController;
  RxBool isTextInputFocused = false.obs;
  RxList<UserModel> searchSuggestions = <UserModel>[].obs;
  final String profileLink = "https://heyo.core/m6ljkB4KJ";
  NewGroupChatController({required this.contactRepository, required this.accountInfoRepo});
  final count = 0.obs;
  @override
  Future<void> onInit() async {
    inputController = TextEditingController();
    await _listenToContacts();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    inputController.dispose();
    _contactasStreamSubscription.cancel();
    super.onClose();
  }

  void increment() => count.value++;

  _listenToContacts() async {
    inputController.addListener(() {
      inputText.value = inputController.text;
      _searchUsers(inputController.text);
    });

    _contactasStreamSubscription =
        (await contactRepository.getContactsStream()).listen((newContacts) {
      // remove the deleted contacts from the list

      if (inputText.value == "") {
        searchSuggestions.value = newContacts;
      }
    });

    super.onInit();
  }

  List<String> mockIconUrls = [
    "https://avatars.githubusercontent.com/u/6644146?v=4",
    "https://avatars.githubusercontent.com/u/7844146?v=4",
    "https://avatars.githubusercontent.com/u/7847725?v=4",
    "https://avatars.githubusercontent.com/u/9947725?v=4",
  ];

  void _searchUsers(String query) async {
    List<UserModel> searchedItems = (await contactRepository.search(query)).toList();

    if (searchedItems.isEmpty) {
      final currentUserCoreId = await accountInfoRepo.getUserAddress();
      if (query.isValidCoreId() && currentUserCoreId != query) {
        //its a new user
        //TODO update fields based on correct data
        searchSuggestions.value = [
          UserModel(
            name: 'unknown',
            iconUrl: (mockIconUrls..shuffle()).first,
            walletAddress: query,
            coreId: query,
          )
        ];
      } else {
        searchSuggestions.value = [];
      }
    } else {
      searchSuggestions.value = searchedItems;
    }

    searchSuggestions.refresh();
  }

  handleScannedValue(String? barcodeValue) {
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
      inputController.text = coreId;
    } catch (e) {
      return;
    }
  }
}
