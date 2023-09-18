import 'package:get/get.dart';
import 'package:heyo/app/modules/add_participate/controllers/add_participate_controller.dart';
import 'package:heyo/app/modules/add_participate/usecase/get_contact_user_use_case.dart';
import 'package:heyo/app/modules/add_participate/usecase/search_contact_user_use_case.dart';
import 'package:heyo/app/modules/calls/data/web_rtc_call_repository.dart';
import 'package:heyo/app/modules/p2p_node/data/account/account_repo.dart';
import 'package:heyo/app/modules/p2p_node/data/key/web3_keys.dart';
import 'package:heyo/app/modules/shared/data/repository/contact_repository.dart';
import 'package:heyo/app/modules/shared/data/repository/db/cache_repository.dart';
import 'package:heyo/app/modules/shared/providers/database/app_database.dart';
import 'package:heyo/app/modules/shared/providers/database/dao/user_provider.dart';
import 'package:heyo/app/modules/shared/providers/secure_storage/secure_storage_provider.dart';
import 'package:heyo/app/modules/shared/bindings/global_bindings.dart';

class AddParticipateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddParticipateController>(
      () => AddParticipateController(
        getContactUserUseCase: GetContactUserUseCase(
          contactRepository: ContactRepository(
            cacheContractor: CacheRepository(
              userProvider: UserProvider(
                appDatabaseProvider: Get.find<AppDatabaseProvider>(),
              ),
            ),
          ),
        ),
        searchContactUserUseCase: SearchContactUserUseCase(
          accountInfo: AccountRepo(
            localProvider: SecureStorageProvider(),
            cryptographyKeyGenerator: Web3Keys(
              web3client: GlobalBindings.web3Client,
            ),
          ),
          contactRepository: ContactRepository(
            cacheContractor: CacheRepository(
              userProvider: UserProvider(
                appDatabaseProvider: Get.find<AppDatabaseProvider>(),
              ),
            ),
          ),
        ),
        callRepository: WebRTCCallRepository(
          callConnectionsHandler: Get.find(),
        ),
      ),
    );
  }
}
