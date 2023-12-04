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
  RxList<String> selectedCoreids = <String>[].obs;

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
    _addMockUsers();
    super.onReady();
  }

  @override
  void onClose() async {
    inputController.dispose();
    _contactasStreamSubscription.cancel();
    await _clearSearchSuggestions();
    super.onClose();
  }

  Future<void> _listenToContacts() async {
    inputController.addListener(() {
      inputText.value = inputController.text;
      _searchUsers(inputController.text);
    });

    _contactasStreamSubscription =
        (await contactRepository.getContactsStream()).listen((newContacts) {
      // remove the deleted contacts from the list

      if (inputText.value == "") {
        searchSuggestions
          ..value = newContacts
          ..sort((a, b) {
            return a.name.compareTo(b.name);
          });
      }
    });
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
    searchSuggestions
      ..sort((a, b) {
        return a.name.compareTo(b.name);
      })
      ..refresh();
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

  Future<void> handleItemTap(UserModel user) async {
    if (selectedCoreids.value.contains(user.coreId)) {
      selectedCoreids.remove(user.coreId);
    } else {
      await contactRepository.getContactById(user.coreId).then((value) {
        if (value == null) {
          contactRepository.addContact(user);
        }
      });
      selectedCoreids.add(user.coreId);
    }
  }

  Future<void> _addMockUsers() async {
    final _mockUsers = <UserModel>[
      UserModel(
        name: "Crapps",
        walletAddress: 'CB92...969A',
        coreId: 'CB92969A',
        iconUrl: "https://raw.githubusercontent.com/Zunawe/identicons/HEAD/examples/poly.png",
        nickname: "Nickname",
      ),
      UserModel(
        name: "Fancy",
        walletAddress: 'CB21...C325',
        coreId: 'CB21C325',
        iconUrl: "https://avatars.githubusercontent.com/u/6634136?v=4",
        isOnline: true,
        isVerified: true,
      ),
      UserModel(
        name: "manly",
        walletAddress: 'CB42...324E',
        coreId: 'CB42324E',
        iconUrl: "https://avatars.githubusercontent.com/u/9801359?v=4",
        isOnline: true,
      ),
    ].obs;

    for (int i = 0; i < _mockUsers.length; i++) {
      await Future.delayed(const Duration(seconds: 3), () async {
        if (searchSuggestions.any((element) => element.coreId == _mockUsers[i].coreId)) {
          return;
        } else {
          await contactRepository.addContact(_mockUsers[i]);
        }
      });
    }
  }

  Future<void> _clearSearchSuggestions() async {
    searchSuggestions.forEach(
      (element) async {
        await contactRepository.deleteContactById(element.coreId);
      },
    );
  }
}
