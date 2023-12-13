import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/call_history_detail/controllers/call_history_detail_controller.dart';
import 'package:heyo/app/modules/calls/shared/data/providers/call_history/call_history_provider.dart';
import 'package:heyo/app/modules/calls/shared/data/repos/call_history/call_history_repo.dart';
import 'package:heyo/app/modules/calls/usecase/contact_availability_use_case.dart';
import 'package:heyo/app/modules/shared/data/providers/database/app_database.dart';
import 'package:heyo/app/modules/shared/data/providers/database/dao/user_provider.dart';
import 'package:heyo/app/modules/shared/data/repository/contact_repository.dart';
import 'package:heyo/app/modules/shared/data/repository/db/cache_repository.dart';

class CallHistoryDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CallHistoryDetailController>(
      () => CallHistoryDetailController(
        callHistoryRepo: CallHistoryRepo(
          callHistoryProvider: CallHistoryProvider(
            appDatabaseProvider: Get.find<AppDatabaseProvider>(),
          ),
        ),
        contactAvailabilityUseCase: ContactAvailabilityUseCase(
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
