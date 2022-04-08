import 'package:get/get.dart';
import 'package:heyo/app/modules/auth/generatPrivateKeys/bindings/generat_private_keys_binding.dart';
import 'package:heyo/app/modules/auth/generatPrivateKeys/views/generat_private_keys_view.dart';

import '../modules/auth/pinCode/bindings/pin_code_binding.dart';
import '../modules/auth/pinCode/views/pin_code_view.dart';
import '../modules/auth/sing-up/bindings/sing_up_binding.dart';
import '../modules/auth/sing-up/views/sing_up_view.dart';

import '../modules/intro/bindings/intro_binding.dart';
import '../modules/intro/views/intro_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.INTRO;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.INTRO,
      page: () => IntroView(),
      binding: IntroBinding(),
    ),
    GetPage(
      name: _Paths.SING_UP,
      page: () => SingUpView(),
      binding: SingUpBinding(),
    ),
    GetPage(
      name: _Paths.PIN_CODE,
      page: () => PinCodeView(),
      binding: PinCodeBinding(),
    ),
    GetPage(
      name: _Paths.GENERAT_PRIVATE_KEYS,
      page: () => GeneratPrivateKeysView(),
      binding: GeneratPrivateKeysBinding(),
    ),
  ];
}
