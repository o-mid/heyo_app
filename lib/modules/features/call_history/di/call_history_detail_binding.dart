import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/shared/data/providers/call_history/call_history_provider.dart';
import 'package:heyo/app/modules/shared/data/providers/database/app_database.dart';
import 'package:heyo/core/di/injector_provider.dart';
import 'package:heyo/modules/features/call_history/data/local_call_history_repo.dart';
import 'package:heyo/modules/features/call_history/presentation/controllers/call_history_detail_controller.dart';
import 'package:heyo/modules/features/contact/domain/contact_repo.dart';
import 'package:heyo/modules/features/contact/usecase/contact_listener_use_case.dart';
import 'package:heyo/modules/features/contact/usecase/delete_contact_use_case.dart';
import 'package:heyo/modules/features/contact/usecase/get_contact_by_id_use_case.dart';

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
        contactListenerUseCase: ContactListenerUseCase(
          contactRepository: inject.get<ContactRepo>(),
        ),
        deleteContactsUseCase: DeleteContactUseCase(
          contactRepository: inject.get<ContactRepo>(),
        ),
        getContactByIdUseCase: GetContactByIdUseCase(
          contactRepository: inject.get<ContactRepo>(),
        ),
      ),
    );
  }
}
