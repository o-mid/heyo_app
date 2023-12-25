import 'package:get/get.dart';
import 'package:heyo/app/modules/add_participate/controllers/add_participate_controller.dart';
import 'package:heyo/app/modules/add_participate/usecase/get_contact_user_use_case.dart';
import 'package:heyo/app/modules/add_participate/usecase/search_contact_user_use_case.dart';

import 'package:heyo/app/modules/calls/data/web_rtc_call_repository.dart';
import 'package:heyo/app/modules/calls/domain/call_repository.dart';
import 'package:heyo/app/modules/calls/main/controllers/call_controller.dart';
import 'package:heyo/app/modules/p2p_node/data/key/web3_keys.dart';
import 'package:heyo/app/modules/shared/bindings/global_bindings.dart';
import 'package:heyo/app/modules/shared/data/providers/database/app_database.dart';
import 'package:heyo/app/modules/shared/data/providers/database/dao/user_provider.dart';
import 'package:heyo/app/modules/shared/data/repository/contact_repository.dart';
import 'package:heyo/app/modules/shared/data/repository/db/cache_repository.dart';


class CallBinding extends Bindings {
  @override
  void dependencies() {
    // Create a new instance of CallRepository

    Get
      ..lazyPut<CallController>(
        () => CallController(
          //* Lazy put CallController with the manually created instance
          callRepository: Get.find(),
          accountInfo: Get.find(),
        ),
      )

      //* Lazy put AddParticipateController with the same instance
      ..put(
        AddParticipateController(
          callRepository: Get.find(),
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
            accountInfoRepo: Get.find(),
            contactRepository: ContactRepository(
              cacheContractor: CacheRepository(
                userProvider: UserProvider(
                  appDatabaseProvider: Get.find<AppDatabaseProvider>(),
                ),
              ),
            ),
          ),
        ),
      );
  }
}
