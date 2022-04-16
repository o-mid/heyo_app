import 'package:get/get.dart';

import '../data/models/user_model.dart';

class NewChatController extends GetxController {
  //TODO: Implement NewChatController

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
  void increment() => count.value++;

// Mock data for the users
  final nearbyUsers = <UserModel>[
    UserModel(
      name: "Crapps Wallbanger",
      walletAddress: 'CB92...969A',
      icon:
          "https://raw.githubusercontent.com/Zunawe/identicons/HEAD/examples/poly.png",
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
}
