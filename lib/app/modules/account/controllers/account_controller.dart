import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/data/repository/crypto_account/crypto_account_repo.dart';

class AccountController extends GetxController {
  final CryptoAccountRepository accountInfoRepo;
  final coreId = "".obs;

  AccountController({required this.accountInfoRepo});

  @override
  void onInit() async {
    super.onInit();
    coreId.value = (await accountInfoRepo.getUserContactAddress()) ?? "";
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
