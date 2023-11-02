import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/data/repository/crypto_account/crypto_account_repo.dart';
import 'package:heyo/app/routes/app_pages.dart';

class AccountController extends GetxController {
  final AccountRepository _accountInfoRepo;
  final coreId = "".obs;

  AccountController({required AccountRepository accountInfoRepo})
      : _accountInfoRepo = accountInfoRepo;

  @override
  void onInit() async {
    super.onInit();
    coreId.value = (await _accountInfoRepo.getUserAddress()) ?? "";
  }

  Future<void> logout() async {
    await _accountInfoRepo.logout();
    await Get.offAllNamed(Routes.INTRO);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
