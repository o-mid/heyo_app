import 'package:get/get.dart';
import 'package:heyo/app/modules/wifi_direct/controllers/wifi_direct_wrapper.dart';
import 'package:heyo/core/di/injector_provider.dart';

import '../../messages/connection/wifi_direct_connection_controller.dart';
import '../../p2p_node/data/key/web3_keys.dart';
import '../../shared/bindings/global_bindings.dart';
import '../../../../modules/features/contact/data/local_contact_repo.dart';
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
        accountInfoRepo: Get.find(),
        // wifiDirectConnectionController: Get.find<UnifiedConnectionController>(),
        contactRepository: LocalContactRepo(
          appDatabaseProvider: inject.get<AppDatabaseProvider>(),
        ),
      ),
    );
  }
}
