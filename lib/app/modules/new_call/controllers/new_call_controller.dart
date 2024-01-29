//import 'package:flutter/material.dart';
//import 'package:get/get.dart';

//import 'package:heyo/app/modules/new_chat/data/models/user_model/user_model.dart';
//import 'package:heyo/app/modules/new_chat/widgets/invite_bttom_sheet.dart';
//import 'package:heyo/app/modules/new_chat/widgets/new_chat_qr_scanner.dart';
//import 'package:heyo/app/modules/shared/data/repository/account/account_repository.dart';
//import 'package:heyo/app/modules/shared/data/repository/contact_repository.dart';
//import 'package:heyo/app/modules/shared/utils/extensions/barcode.extension.dart';
//import 'package:heyo/app/modules/shared/utils/extensions/string.extension.dart';

//class NewCallController extends GetxController {
//  NewCallController({
//    required this.contactRepository,
//    required this.accountInfoRepo,
//  });

//  late TextEditingController inputController;
//  final ContactRepository contactRepository;
//  final AccountRepository accountInfoRepo;

//  @override
//  void onInit() {
//    inputController = TextEditingController();

//    searchUsers('');
//    inputController.addListener(() {
//      searchUsers(inputController.text);
//    });
//    super.onInit();
//  }

//  @override
//  void onClose() {
//    inputController.dispose();
//  }

//  RxList<UserModel> searchSuggestions = <UserModel>[].obs;

//  final profileLink = "https://heyo.core/m6ljkB4KJ";

//  void searchUsers(String query) async {
//    //TODO icon and chatmodel should be filled with correct data
//    final searchedItems = (await contactRepository.search(query)).toList();

//    if (searchedItems.isEmpty) {
//      final currentUserCoreId = await accountInfoRepo.getUserAddress();
//      if (query.isValidCoreId() && currentUserCoreId != query) {
//        //its a new user
//        //TODO update fields based on correct data
//        searchSuggestions.value = [
//          UserModel(
//            name: 'unknown',
//            walletAddress: query,
//            coreId: query,
//          )
//        ];
//      } else {
//        searchSuggestions.value = [];
//      }
//    } else {
//      searchSuggestions.value = searchedItems;
//    }

//    searchSuggestions.refresh();
//  }

//  RxBool isTextInputFocused = false.obs;

//  qrBottomSheet() {
//    openQrScannerBottomSheet(handleScannedValue);
//  }

//  inviteBottomSheet() {
//    openInviteBottomSheet(profileLink: profileLink);
//  }

//  handleScannedValue(String? barcodeValue) {
//    // TODO: Implement the right filter logic for QRCode
//    if (barcodeValue == null) {
//      // Todo(qr)
//      return;
//    }
//    try {
//      final coreId = barcodeValue.getCoreId();

//      Get.back();
//      isTextInputFocused.value = true;
//      // this will set the input field to the scanned value and serach for users
//      inputController.text = coreId;
//    } catch (e) {
//      return;
//    }
//  }
//}
