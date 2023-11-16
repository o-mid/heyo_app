import 'package:get/get.dart';
import 'package:heyo/app/modules/splash/data/repositoty/splash_repository.dart';
import 'package:heyo/app/modules/splash/controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      SplashController(
        accountInfoRepo: Get.find(),
        splashRepository: SplashRepository(
          notificationProvider: Get.find(),
          registryProvider: Get.find(),
        ),
      ),
    );
  }
}
