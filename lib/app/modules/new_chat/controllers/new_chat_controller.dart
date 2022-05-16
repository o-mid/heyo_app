import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/chats/data/models/chat_model.dart';
import 'package:heyo/app/modules/new_chat/data/models/new_chat_view_arguments_model.dart';
import 'package:heyo/app/modules/new_chat/widgets/new_chat_qr_scaner.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../data/models/filter_model.dart';
import '../data/models/profile_model.dart';
import '../data/models/user_model.dart';
import '../widgets/invite_bttom_sheet.dart';

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
    nearbyUsers
        .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    super.onInit();
  }

  @override
  void onReady() {
    if (Get.arguments != null) {
      // if openQrScaner is set to true then this will open the qr scaner
      // and search for users using qr code right after initializing

      final args = Get.arguments as NewchatArgumentsModel;
      if (args.openQrScaner) {
        openQrScanerBottomSheet(handleScannedValue);
      }
      // if openInviteBottomSheet is set to true then this will
      //open the invite bottom sheet right after initializing

      if (args.openInviteBottomSheet) {
        openInviteBottomSheet(profile);
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
      chatModel: ChatModel(
        name: "Crapps Wallbanger",
        icon:
            "https://raw.githubusercontent.com/Zunawe/identicons/HEAD/examples/poly.png",
        lastMessage:
            "I'm still waiting for the reply. I'll let you know once they get back to me.",
        timestamp: "15:45",
      ),
    ),
    UserModel(
      name: "Fancy Potato",
      walletAddress: 'CB21...C325',
      icon: "https://avatars.githubusercontent.com/u/6634136?v=4",
      isOnline: true,
      isVerified: true,
      chatModel: ChatModel(
        name: "Fancy Potato",
        icon: "https://avatars.githubusercontent.com/u/6634136?v=4",
        lastMessage:
            "I can arrange the meeting with her tomorrow if you're ok with that.",
        timestamp: "Yesterday",
        isOnline: true,
        isVerified: true,
        notificationCount: 4,
      ),
    ),
    UserModel(
      name: "manly Cupholder",
      walletAddress: 'CB42...324E',
      icon: "https://avatars.githubusercontent.com/u/9801359?v=4",
      isOnline: true,
      chatModel: ChatModel(
        name: "Manly Cupholder",
        icon: "https://avatars.githubusercontent.com/u/9801359?v=4",
        lastMessage: "That's nice!",
        timestamp: "15/01/2022",
        isOnline: true,
        notificationCount: 11,
      ),
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
    searchSuggestions
        .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
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
