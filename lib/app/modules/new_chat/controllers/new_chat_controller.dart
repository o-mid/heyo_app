import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/new_chat/data/models/new_chat_view_arguements_model.dart';
import 'package:heyo/app/modules/new_chat/widgets/new_chat_qr_scaner.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../data/models/filter_model.dart';
import '../data/models/profile_model.dart';
import '../data/models/user_model.dart';

class NewChatController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animController;
  late Animation<double> animation;
  late TextEditingController inputController;
// in nearby users Tab after 3 seconds the refresh button will be visible
  RxBool refreshBtnVisibility = false.obs;
  void makeRefreshBtnVisible() {
    Future.delayed(const Duration(seconds: 3), () {
      refreshBtnVisibility.value = true;
    });
  }

  @override
  void onInit() {
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
    inputController.addListener(() {
      searchUsers(inputController.text);
    });

    super.onInit();
  }

  @override
  void onReady() {
    // if openQrScaner is set to true then this will open the qr scaner
    // and search for users using qr code right after initializing

    if (Get.arguments != null) {
      final args = Get.arguments as NewchatArgumentsModel;
      if (args.openQrScaner) {
        openQrScanerBottomSheet(handleScannedValue);
      }
    }
    super.onReady();
  }

  @override
  void onClose() {
    animController.dispose();
    inputController.dispose();
  }

// Mock data for user profile
  final profile = ProfileModel(
      name: "Sample",
      link: "https://heyo.core/m6ljkB4KJ",
      walletAddress: "CB75...684A");

// Mock data for the users
  final nearbyUsers = <UserModel>[
    UserModel(
      name: "Crapps Wallbanger",
      walletAddress: 'CB92...969A',
      icon:
          "https://raw.githubusercontent.com/Zunawe/identicons/HEAD/examples/poly.png",
      Nickname: "Nickname",
    ),
    UserModel(
      name: "Fancy Potato",
      walletAddress: 'CB21...C325',
      icon: "https://avatars.githubusercontent.com/u/6634136?v=4",
      isOnline: true,
      isVerified: true,
    ),
    UserModel(
      name: "Manly Cupholder",
      walletAddress: 'CB42...324E',
      icon: "https://avatars.githubusercontent.com/u/9801359?v=4",
      isOnline: true,
    ),
  ].obs;

// Mock filters for the users
  RxList<FilterModel> filters = [
    FilterModel(
      title: "Verified",
      isActive: false.obs,
    ),
  ].obs;

  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  void onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));

    refreshController.refreshCompleted();
  }

  RxList<UserModel> searchSuggestions = <UserModel>[].obs;

  void searchUsers(String query) {
    searchSuggestions.value = nearbyUsers.where((user) {
      String username = user.name.toLowerCase();
      String inputedQuery = query.toLowerCase();
      return username.contains(inputedQuery);
    }).toList();
    searchSuggestions.refresh();
  }

  RxBool isTextInputFocused = false.obs;

  handleScannedValue(QRViewController qrControllerDt) {
    // TODO: Implement the right filter logic for QRCode
    qrControllerDt.scannedDataStream.listen((element) {
      qrControllerDt.pauseCamera();
      Get.back();
      isTextInputFocused.value = true;
      // this will set the input field to the scanned value and serach for users
      inputController.text = element.code.toString();
    });
  }
}
