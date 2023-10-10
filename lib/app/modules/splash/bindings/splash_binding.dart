import 'package:get/get.dart';
import 'package:heyo/app/modules/p2p_node/data/account/account_repo.dart';
import 'package:heyo/app/modules/p2p_node/data/key/web3_keys.dart';
import 'package:heyo/app/modules/shared/bindings/global_bindings.dart';
import 'package:heyo/app/modules/shared/providers/secure_storage/secure_storage_provider.dart';

import '../controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashController(accountInfo: AccountRepo(
      localProvider: SecureStorageProvider(),
      cryptographyKeyGenerator: Web3Keys(
        web3client: GlobalBindings.web3Client,
      ),
    ),),);
  }
}
