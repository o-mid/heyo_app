import 'package:core_web3dart/web3dart.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/bindings/global_bindings.dart';
import 'package:heyo/app/modules/shared/data/providers/blockchain/app_blockchain_provider.dart';
import 'package:heyo/app/modules/shared/data/providers/network/network_credentials.dart';
import 'package:heyo/app/modules/shared/data/providers/registery/app_registry_provider.dart';
import 'package:heyo/app/modules/splash/data/repositoty/splash_repository.dart';
import 'package:http/http.dart' as http;

import 'package:heyo/app/modules/splash/controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      SplashController(
        accountInfoRepo: Get.find(),
        splashRepository: SplashRepository(
          notificationProvider: Get.find(),
          registryProvider: AppRegistryProvider(
            blockChainProvider: AppBlockchainProvider(),
            web3: Web3Client(BLOCKCHAIN_ADDR, http.Client(), '', ''),
            storageProvider: GlobalBindings.secureStorageProvider,
          ),
        ),
      ),
    );
  }
}
