import 'package:get/get.dart';
import 'package:heyo/app/modules/p2p_node/data/account/account_repo.dart';
import 'package:heyo/app/modules/p2p_node/data/key/web3_keys.dart';
import 'package:heyo/app/modules/shared/bindings/global_bindings.dart';
import 'package:heyo/app/modules/shared/data/repository/contact_repository.dart';
import 'package:heyo/app/modules/shared/data/repository/db/cache_repository.dart';
import 'package:heyo/app/modules/shared/providers/database/dao/user_contact_provider.dart';
import 'package:heyo/app/modules/shared/providers/secure_storage/secure_storage_provider.dart';

import '../controllers/new_call_controller.dart';

class NewCallBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewCallController>(
      () => NewCallController(
        accountInfo: AccountRepo(
          localProvider: SecureStorageProvider(),
          cryptographyKeyGenerator: Web3Keys(web3client: GlobalBindings.web3Client),
        ),
        contactRepository: ContactRepository(
          cacheContractor: CacheRepository(
            userContact: UserContactProvider(),
          ),
        ),
      ),
    );
  }
}
