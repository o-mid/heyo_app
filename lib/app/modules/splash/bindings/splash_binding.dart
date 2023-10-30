import 'package:get/get.dart';
import 'package:heyo/app/modules/p2p_node/data/key/web3_keys.dart';
import 'package:heyo/app/modules/shared/bindings/global_bindings.dart';
import 'package:heyo/app/modules/shared/providers/secure_storage/secure_storage_provider.dart';
import 'package:heyo/app/modules/shared/utils/crypto/crypto_validation.dart';
import 'package:heyo/app/modules/splash/data/repositoty/splash_repository.dart';

import '../controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      SplashController(
        accountInfoRepo: Get.find(),
      ),
    );
  }
}
