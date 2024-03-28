import 'package:get/get.dart';

import 'package:heyo/app/modules/calls/new_call/controllers/new_call_controller.dart';
import 'package:heyo/app/modules/calls/usecase/get_contact_user_use_case.dart';
import 'package:heyo/app/modules/shared/data/providers/database/app_database.dart';
import 'package:heyo/app/modules/shared/data/providers/database/dao/user_provider.dart';
import 'package:heyo/modules/features/contact/data/local_contact_repo.dart';
import 'package:heyo/app/modules/shared/data/repository/db/cache_repository.dart';

class NewCallBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewCallController>(
      () => NewCallController(
        accountInfoRepo: Get.find(),
        contactRepository: LocalContactRepo(
          cacheContractor: CacheRepository(
            userProvider: UserProvider(
                appDatabaseProvider: Get.find<AppDatabaseProvider>()),
          ),
        ),
        getContactUserUseCase: GetContactUserUseCase(
          contactRepository: LocalContactRepo(
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
