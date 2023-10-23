import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/p2p_node/data/account/account_info.dart';
import 'package:heyo/app/routes/app_pages.dart';

class SplashController extends GetxController {
  SplashController({required this.accountInfo});

  final AccountInfo accountInfo;

  //Todo accountInfo
  _checkIfAuthenticated() async {
    final isLogin = (await accountInfo.getCorePassCoreId() != null) &&
        (await accountInfo.getSignature() != null);
    if (true) {
      await Get.offAllNamed(Routes.HOME);
    } else {
      await Get.offAllNamed(Routes.INTRO);
    }
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

}
