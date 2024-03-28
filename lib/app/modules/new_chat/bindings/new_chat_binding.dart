import 'package:get/get.dart';
import 'package:heyo/app/modules/p2p_node/data/key/web3_keys.dart';
import 'package:heyo/modules/features/contact/data/local_contact_repo.dart';
import 'package:heyo/app/modules/shared/data/repository/db/cache_repository.dart';
import 'package:heyo/app/modules/shared/data/providers/database/app_database.dart';
import 'package:heyo/app/modules/shared/data/providers/database/dao/user_provider.dart';
import 'package:heyo/app/modules/shared/data/providers/secure_storage/secure_storage_provider.dart';

import '../controllers/new_chat_controller.dart';
import 'package:heyo/app/modules/shared/bindings/global_bindings.dart';

class NewChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewChatController>(
      () => NewChatController(
          accountInfoRepo: Get.find(),
          contactRepository: LocalContactRepo(
              cacheContractor: CacheRepository(
                  userProvider: UserProvider(
                      appDatabaseProvider: Get.find<AppDatabaseProvider>())))),
    );
  }
}
