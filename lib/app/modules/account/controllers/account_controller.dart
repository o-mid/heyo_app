import 'package:get/get.dart';
import 'package:heyo/app/modules/p2p_node/data/account/account_info.dart';

class AccountController extends GetxController {
  final AccountInfo accountInfo;
  final coreId = "".obs;

  AccountController({required this.accountInfo});

  @override
  void onInit() async {
    super.onInit();
    coreId.value = (await accountInfo.getCorePassCoreId()) ?? "";
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
