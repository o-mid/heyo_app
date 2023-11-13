import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/shared/data/providers/call_history/call_history_provider.dart';
import 'package:heyo/app/modules/calls/shared/data/repos/call_history/call_history_repo.dart';
import 'package:heyo/app/modules/shared/data/providers/database/app_database.dart';

import '../../../shared/data/repository/contact_repository.dart';
import '../../../shared/data/repository/db/cache_repository.dart';
import '../../../shared/data/providers/database/dao/user_provider.dart';
import '../controllers/user_call_history_controller.dart';

class UserCallHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserCallHistoryController>(
      () => UserCallHistoryController(
          callHistoryRepo: CallHistoryRepo(
            callHistoryProvider:
                CallHistoryProvider(appDatabaseProvider: Get.find<AppDatabaseProvider>()),
          ),
          contactRepository: ContactRepository(
              cacheContractor: CacheRepository(
                  userProvider:
                      UserProvider(appDatabaseProvider: Get.find<AppDatabaseProvider>())))),
    );
  }
}
