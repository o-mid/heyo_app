import 'package:get/get.dart';
import 'package:heyo/modules/call/data/web_rtc_call_repository.dart';

import 'package:heyo/modules/call/presentation/add_participate/add_participate_controller.dart';
import 'package:heyo/app/modules/calls/usecase/get_contact_user_use_case.dart';
import 'package:heyo/app/modules/shared/data/providers/database/app_database.dart';
import 'package:heyo/app/modules/shared/data/providers/database/dao/user_provider.dart';
import 'package:heyo/modules/features/contact/data/local_contact_repo.dart';
import 'package:heyo/app/modules/shared/data/repository/db/cache_repository.dart';

class AddParticipateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddParticipateController>(
      () => AddParticipateController(
        accountInfoRepo: Get.find(),
        callRepository: Get.find<WebRTCCallRepository>(),
        getContactUserUseCase: GetContactUserUseCase(
          contactRepository: LocalContactRepo(
            cacheContractor: CacheRepository(
              userProvider: UserProvider(
                appDatabaseProvider: Get.find<AppDatabaseProvider>(),
              ),
            ),
          ),
        ),
        //searchContactUserUseCase: SearchContactUserUseCase(
        //  accountInfoRepo: Get.find(),
        //  contactRepository: ContactRepository(
        //    cacheContractor: CacheRepository(
        //      userProvider: UserProvider(
        //        appDatabaseProvider: Get.find<AppDatabaseProvider>(),
        //      ),
        //    ),
        //  ),
        //),
      ),
    );
  }
}
