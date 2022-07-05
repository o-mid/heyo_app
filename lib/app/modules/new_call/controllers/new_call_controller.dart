import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/new_chat/data/models/profile_model.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model.dart';
import 'package:heyo/app/modules/p2p_node/data/account/account_info.dart';
import 'package:heyo/app/modules/shared/data/repository/contact_repository.dart';
import 'package:heyo/app/modules/shared/utils/extensions/barcode.extension.dart';
import 'package:heyo/app/modules/shared/utils/extensions/string.extension.dart';

class NewCallController extends GetxController {
  late TextEditingController inputController;
  final ContactRepository contactRepository;
  final AccountInfo accountInfo;

  NewCallController({
    required this.contactRepository,
    required this.accountInfo,
  });

  @override
  void onInit() {
    inputController = TextEditingController();

    searchUsers('');
    inputController.addListener(() {
      searchUsers(inputController.text);
    });
    super.onInit();
  }

  @override
  void onClose() {
    inputController.dispose();
  }

  RxList<UserModel> searchSuggestions = <UserModel>[].obs;

  final profile = ProfileModel(
      name: "Sample", link: "https://heyo.core/m6ljkB4KJ", walletAddress: "CB75...684A");

  void searchUsers(String query) async {
    //TODO icon and chatmodel should be filled with correct data
    List<UserModel> searchedItems = (await contactRepository.search(query))
        .map((userContact) => UserModel(
              name: userContact.nickname,
              icon: userContact.icon,
              walletAddress: userContact.coreId,
              isContact: true,
            ))
        .toList();

    if (searchedItems.isEmpty) {
      String? currentUserCoreId = await accountInfo.getCoreId();
      if (query.isValid() && currentUserCoreId != query) {
        //its a new user
        //TODO update fields based on correct data
        searchSuggestions.value = [
          UserModel(
            name: 'unknown',
            icon: ([
              "https://raw.githubusercontent.com/Zunawe/identicons/HEAD/examples/poly.png",
              "https://avatars.githubusercontent.com/u/6634136?v=4",
              "https://avatars.githubusercontent.com/u/9801359?v=4",
            ]..shuffle())
                .first,
            walletAddress: query,
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

  RxBool isTextInputFocused = false.obs;

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
