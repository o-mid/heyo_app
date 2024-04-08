import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/shared/data/providers/call_history/call_history_provider.dart';
import 'package:heyo/app/modules/calls/usecase/contact_name_use_case.dart';
import 'package:heyo/app/modules/shared/data/providers/database/app_database.dart';
import 'package:heyo/core/di/injector_provider.dart';
import 'package:heyo/modules/features/call_history/data/local_call_history_repo.dart';
import 'package:heyo/modules/features/call_history/presentation/controllers/call_history_detail_controller.dart';
import 'package:heyo/modules/features/contact/data/local_contact_repo.dart';
import 'package:heyo/modules/features/contact/domain/contact_repo.dart';

class CallHistoryDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CallHistoryDetailController>(
      () => CallHistoryDetailController(
        callHistoryRepo: LocalCallHistoryRepo(
          callHistoryProvider: CallHistoryProvider(
            appDatabaseProvider: Get.find<AppDatabaseProvider>(),
          ),
        ),
        contactNameUseCase: ContactNameUseCase(
          contactRepository: inject.get<ContactRepo>(),
        ),
        contactRepository: inject.get<ContactRepo>(),
      ),
    );
  }
}
