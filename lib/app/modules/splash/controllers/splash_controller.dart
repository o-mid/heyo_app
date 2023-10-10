import 'package:get/get.dart';
import 'package:heyo/app/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:heyo/app/modules/p2p_node/data/account/account_info.dart';

class SplashController extends GetxController {
  SplashController({required this.accountInfo});

  final AccountInfo accountInfo;

  //Todo accountInfo
  _checkIfAuthenticated() async {
    final isLogin = (await accountInfo.getCoreId() != null) &&
        (await accountInfo.getSignature() != null);
    if (isLogin) {
      await Get.offAllNamed(Routes.HOME);
    } else {
      await Get.offAllNamed(Routes.INTRO);
    }
    //await Future.delayed(const Duration(milliseconds: 500), () {});
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

//@override
//void onClose() {}
}
