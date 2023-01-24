import 'package:get/get.dart';

import '../../p2p_node/data/account/account_info.dart';

class WifiDirectController extends GetxController {
  final AccountInfo accountInfo;

  WifiDirectController({required this.accountInfo});
  final coreId = "".obs;
  final count = 0.obs;
  @override
  Future<void> onInit() async {
    await setCoreid();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
  Future<void> setCoreid() async {
    coreId.value = (await accountInfo.getCoreId()) ?? "";
  }
}
