import 'dart:typed_data';

import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/p2p_node/data/account/account_info.dart';
import 'package:heyo/app/modules/splash/data/repositoty/splash_repository.dart';
import 'package:heyo/app/routes/app_pages.dart';

class SplashController extends GetxController {
  SplashRepository splashRepository;

  SplashController({required this.accountInfo, required this.splashRepository});

  final AccountInfo accountInfo;

  //Todo accountInfo
  _checkIfAuthenticated() async {
    final signature = await accountInfo.getSignature();
    if (signature == null) {
      await _goToLogin();
      return;
    }
    // final publicKey = await accountInfo.getPublicKey();
    // final localCoreId = await accountInfo.getLocalCoreId();
    //
    // final isValid =
    //     splashRepository.isSignatureValid(localCoreId!, signature, publicKey!);
    // if (isValid) {
    await Get.offAllNamed(Routes.HOME);
    //   return;
    // } else {
    //   await _goToLogin();
    // }
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
