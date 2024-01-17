import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/chats/data/models/chat_model.dart';
import 'package:heyo/app/modules/new_chat/data/models/new_chat_view_arguments_model.dart';
import 'package:heyo/app/modules/new_chat/widgets/new_chat_qr_scanner.dart';
import 'package:heyo/app/modules/shared/data/repository/account/account_repository.dart';
import 'package:heyo/app/modules/shared/data/repository/contact_repository.dart';
import 'package:heyo/app/modules/shared/utils/extensions/barcode.extension.dart';
import 'package:heyo/app/modules/shared/utils/extensions/string.extension.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../data/models/filter_model.dart';
import '../data/models/user_model/user_model.dart';
import '../widgets/invite_bttom_sheet.dart';

class NewChatController extends GetxController with GetSingleTickerProviderStateMixin {
  late AnimationController animController;
  late Animation<double> animation;
  late TextEditingController inputController;
  final ContactRepository contactRepository;
  final AccountRepository accountInfoRepo;
  final inputFocusNode = FocusNode();
  final inputText = "".obs;
  late StreamSubscription _contactasStreamSubscription;

  NewChatController({required this.contactRepository, required this.accountInfoRepo});

// in nearby users Tab after 3 seconds the refresh button will be visible
  RxBool refreshBtnVisibility = false.obs;

  void makeRefreshBtnVisible() {
    Future.delayed(const Duration(seconds: 3), () {
      refreshBtnVisibility.value = true;
    });
  }

  @override
  Future<void> onInit() async {
    // animation for refresh button
    animController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    animation = Tween<double>(
      begin: 0.9,
      end: 1.05,
    ).animate(animController);

    inputController = TextEditingController();
    await listenToContacts();
    super.onInit();
  }

  @override
  void onReady() {
    if (Get.arguments != null) {
      // if openQrScaner is set to true then this will open the qr scaner
      // and search for users using qr code right after initializing

      final args = Get.arguments as NewChatArgumentsModel;
      if (args.openQrScanner) {
        openQrScannerBottomSheet(handleScannedValue);
      }
      // if openInviteBottomSheet is set to true then this will
      //open the invite bottom sheet right after initializing

      if (args.openInviteBottomSheet) {
        // TODO: ADD correct profile Invite Links
        openInviteBottomSheet(profileLink: profileLink);
      }
    }
    super.onReady();
  }

  @override
  void onClose() {
    animController.dispose();
    inputController.dispose();
    _contactasStreamSubscription.cancel();
  }

  final String profileLink = "https://heyo.core/m6ljkB4KJ";

// Mock data for the users
  final nearbyUsers = <UserModel>[
    UserModel(
      name: "Crapps Wallbanger",
      walletAddress: 'CB92...969A',
      coreId: 'CB92...969A',
      nickname: "Nickname",
    ),
    UserModel(
      name: "Fancy Potato",
      walletAddress: 'CB21...C325',
      coreId: 'CB21...C325',
      isOnline: true,
      isVerified: true,
    ),
    UserModel(
      name: "manly Cupholder",
      walletAddress: 'CB42...324E',
      coreId: 'CB42...324E',
      isOnline: true,
    ),
  ].obs;

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

  RefreshController refreshController = RefreshController(initialRefresh: false);

  void onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));

    refreshController.refreshCompleted();
  }

  RxList<UserModel> searchSuggestions = <UserModel>[].obs;

  listenToContacts() async {
    inputController.addListener(() {
      inputText.value = inputController.text;
      searchUsers(inputController.text);
    });

    _contactasStreamSubscription =
        (await contactRepository.getContactsStream()).listen((newContacts) {
      // remove the deleted contacts from the list

      if (inputText.value == "") {
        searchSuggestions.value = newContacts;
      }
    });
    nearbyUsers.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    super.onInit();
  }

  void searchUsers(String query) async {
    //TODO icon and chatmodel should be filled with correct data
    List<UserModel> searchedItems = (await contactRepository.search(query)).toList();

    if (searchedItems.isEmpty) {
      final currentUserCoreId = await accountInfoRepo.getUserAddress();
      if (query.isValidCoreId() && currentUserCoreId != query) {
        //its a new user
        //TODO update fields based on correct data
        searchSuggestions.value = [
          UserModel(
            name: 'unknown',
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
