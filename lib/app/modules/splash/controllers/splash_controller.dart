import 'dart:typed_data';

import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/data/repository/crypto_account/crypto_account_repo.dart';
import 'package:heyo/app/modules/splash/data/repositoty/splash_repository.dart';
import 'package:heyo/app/routes/app_pages.dart';

class SplashController extends GetxController {
  SplashController({
    required this.accountInfoRepo,
  });

  final CryptoAccountRepository accountInfoRepo;

  //Todo accountInfo
  _checkIfAuthenticated() async {
    final hasAccount = await accountInfoRepo.hasAccount();
    if (hasAccount == false) {
      await _goToLogin();
      return;
    }
    await Get.offAllNamed(Routes.HOME);
  }

  @override
  void onClose() {
    FlutterNativeSplash.remove();
    super.onClose();
  }

  @override
  void onReady() {
    super.onReady();
    _checkIfAuthenticated();
  }

  Future<void> _goToLogin() async {
    await Get.offAllNamed(Routes.INTRO);
  }
}
