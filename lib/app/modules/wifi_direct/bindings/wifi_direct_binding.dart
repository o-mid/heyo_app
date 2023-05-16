import 'package:get/get.dart';

import '../../messaging/controllers/wifi_direct_connection_controller.dart';
import '../../p2p_node/data/account/account_repo.dart';
import '../../p2p_node/data/key/web3_keys.dart';
import '../../shared/bindings/global_bindings.dart';
import '../../shared/providers/secure_storage/secure_storage_provider.dart';
import '../controllers/wifi_direct_controller.dart';

class WifiDirectBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WifiDirectController>(
      () => WifiDirectController(
        accountInfo: AccountRepo(
          localProvider: SecureStorageProvider(),
          cryptographyKeyGenerator: Web3Keys(web3client: GlobalBindings.web3Client),
        ),
        heyoWifiDirect: GlobalBindings.heyoWifiDirect,
        wifiDirectConnectionController: Get.find<WifiDirectConnectionController>(),
      ),
    );
  }
}
