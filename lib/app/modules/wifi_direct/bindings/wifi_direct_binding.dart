import 'package:get/get.dart';
import 'package:heyo/app/modules/wifi_direct/controllers/wifi_direct_wrapper.dart';

import '../../messages/connection/wifi_direct_connection_controller.dart';
import '../../p2p_node/data/key/web3_keys.dart';
import '../../shared/bindings/global_bindings.dart';
import '../../shared/data/repository/contact_repository.dart';
import '../../shared/data/repository/db/cache_repository.dart';
import '../../shared/data/providers/database/app_database.dart';
import '../../shared/data/providers/database/dao/user_provider.dart';
import '../../shared/data/providers/secure_storage/secure_storage_provider.dart';
import '../controllers/wifi_direct_controller.dart';

class WifiDirectBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WifiDirectController>(
      () => WifiDirectController(
          /*accountInfo: AccountRepo(
          localProvider: SecureStorageProvider(),
          cryptographyKeyGenerator: Web3Keys(web3client: GlobalBindings.web3Client),
        ),
        wifiDirectConnectionController: Get.find<UnifiedConnectionController>(),
        contactRepository: ContactRepository(
          cacheContractor: CacheRepository(
              userProvider: UserProvider(appDatabaseProvider: Get.find<AppDatabaseProvider>())),
        ),*/
          ),
    );
  }
}
