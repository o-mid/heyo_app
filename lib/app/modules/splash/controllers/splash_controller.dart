import 'dart:typed_data';

import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/data/providers/notifications/notification_provider.dart';
import 'package:heyo/app/modules/shared/data/repository/crypto_account/account_repository.dart';
import 'package:heyo/app/modules/splash/data/repositoty/splash_repository.dart';
import 'package:heyo/app/routes/app_pages.dart';

class SplashController extends GetxController {

  SplashController({
    required this.accountInfoRepo,
    required this.splashRepository,
  });

  final AccountRepository accountInfoRepo;
  final SplashRepository splashRepository;

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
  void onReady() async {
    super.onReady();
    if (await splashRepository.fetchAllRegistries()) {
      await splashRepository.sendFCMToken();
    } else {
      await Get.snackbar(
        'Registry Retrieval Failed',
        'Could not fetch registry, Some functionalities may not work properly',
      ).show();
    }
    _checkIfAuthenticated();
  }

  Future<void> _goToLogin() async {
    await Get.offAllNamed(Routes.INTRO);
  }
}
