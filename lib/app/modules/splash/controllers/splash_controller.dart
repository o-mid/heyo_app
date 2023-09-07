import 'package:get/get.dart';
import 'package:heyo/app/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class SplashController extends GetxController {
  SplashController();

  checkIfAuthenticated() async {
    //TODO: just use prefs for test, users will see this screen once
    // it will change when the corePass integration complete
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //prefs.setBool("isLogin", false);
    bool isLogin = prefs.getBool("isLogin") ?? false;
    if (isLogin) {
      Get.offAllNamed(Routes.HOME);
    } else {
      Get.offAllNamed(Routes.INTRO);
    }
    await Future.delayed(const Duration(milliseconds: 500), () {
      FlutterNativeSplash.remove();
    });
  }

  @override
  void onReady() {
    super.onReady();
    checkIfAuthenticated();
  }

  //@override
  //void onClose() {}
}
