import 'package:get/get.dart';
import 'package:heyo/app/modules/p2p_node/data/key/web3_keys.dart';
import 'package:heyo/app/modules/shared/bindings/global_bindings.dart';
import 'package:heyo/app/modules/shared/data/repository/contact_repository.dart';
import 'package:heyo/app/modules/shared/data/repository/db/cache_repository.dart';
import 'package:heyo/app/modules/shared/providers/database/app_database.dart';
import 'package:heyo/app/modules/shared/providers/database/dao/user_provider.dart';
import 'package:heyo/app/modules/shared/providers/secure_storage/secure_storage_provider.dart';

import '../controllers/new_call_controller.dart';

class NewCallBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewCallController>(
      () => NewCallController(
        accountInfoRepo: Get.find(),
        contactRepository: ContactRepository(
          cacheContractor: CacheRepository(
            userProvider: UserProvider(
                appDatabaseProvider: Get.find<AppDatabaseProvider>()),
          ),
        ),
      ),
    );
  }
}
