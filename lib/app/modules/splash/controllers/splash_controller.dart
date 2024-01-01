import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/connection/domain/connection_contractor.dart';
import 'package:heyo/app/modules/shared/data/repository/account/account_repository.dart';
import 'package:heyo/app/modules/shared/widgets/snackbar_widget.dart';
import 'package:heyo/app/modules/splash/data/repositoty/splash_repository.dart';
import 'package:heyo/app/routes/app_pages.dart';

class SplashController extends GetxController {
  SplashController({
    required this.accountInfoRepo,
    required this.splashRepository,
    required this.connectionContractor,
  });

  final AccountRepository accountInfoRepo;
  final SplashRepository splashRepository;
  final ConnectionContractor connectionContractor;

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
    await splashRepository.removeStorageOnFirstRun();
    _checkIfAuthenticated();
  }

  Future<void> _goToLogin() async {
    await Get.offAllNamed(Routes.INTRO);
  }
}
