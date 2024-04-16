import 'package:get/get.dart';
import 'package:heyo/modules/call/data/call_status_provider.dart';
import 'package:heyo/modules/call/data/ios_call_kit/ios_call_kit_provider.dart';
import 'package:heyo/modules/call/data/rtc/multiple_call_connection_handler.dart';
import 'package:heyo/modules/call/data/rtc/single_call_web_rtc_connection.dart';
import 'package:heyo/modules/call/data/signaling/call_signaling.dart';
import 'package:heyo/modules/call/data/web_rtc_call_repository.dart';
import 'package:heyo/modules/call/data/call_requests_processor.dart';
import 'package:heyo/modules/call/data/call_status_observer.dart';
import 'package:heyo/app/modules/calls/shared/data/providers/call_history/call_history_provider.dart';
import 'package:heyo/modules/features/call_history/domain/call_history_repo.dart';
import 'package:heyo/modules/features/call_history/data/local_call_history_repo.dart';
import 'package:heyo/modules/features/contact/usecase/contact_listener_use_case.dart';
import 'package:heyo/modules/features/contact/usecase/get_contact_by_id_use_case.dart';
import 'package:heyo/modules/features/contact/usecase/get_contact_name_by_id_use_case.dart';
import 'package:heyo/app/modules/shared/bindings/priority_bindings_interface.dart';
import 'package:heyo/app/modules/shared/controllers/call_history_observer.dart';
import 'package:heyo/app/modules/shared/data/providers/database/app_database.dart';
import 'package:heyo/app/modules/shared/data/providers/database/dao/user_provider.dart';
import 'package:heyo/modules/features/contact/data/local_contact_repo.dart';
import 'package:heyo/app/modules/shared/data/repository/db/cache_repository.dart';
import 'package:heyo/modules/features/call_history/presentation/controllers/call_history_controller.dart';

class CallBindings with NormalPriorityBindings {
  @override
  void executeNormalPriorityBindings() {
    Get
      ..put(CallSignaling(
          connectionContractor: Get.find(), notificationProvider: Get.find()))
      ..put(CallStatusProvider(callSignaling: Get.find()), permanent: true)
      ..put(
        CallConnectionsHandler(
            callStatusProvider: Get.find(),
            singleCallWebRTCBuilder: SingleCallWebRTCBuilder(
              connectionContractor: Get.find(),
            ),
            callSignaling: Get.find()),
        permanent: true,
      )
      ..put<WebRTCCallRepository>(
        WebRTCCallRepository(
          callConnectionsHandler: Get.find<CallConnectionsHandler>(),
        ),
        permanent: true,
      )
      ..put(
          CallRequestsProcessor(
            connectionContractor: Get.find(),
            callStatusProvider: Get.find(),
            callConnectionsHandler: Get.find(),
          ),
          permanent: true)
      ..put(
        CallKitProvider(
          accountInfoRepo: Get.find(),
          getContactByIdUseCase: GetContactByIdUseCase(
            contactRepository: Get.find(),
          ),
          callRepository: Get.find<WebRTCCallRepository>(),
        ),
        permanent: true,
      )
      ..put(
        CallStatusObserver(
            callStatusProvider: Get.find(),
            accountInfoRepo: Get.find(),
            notificationsController: Get.find(),
            getContactByIdUseCase: GetContactByIdUseCase(
              contactRepository: Get.find(),
            ),
            appLifeCycleController: Get.find(),
            iOSCallKitProvider: Get.find()),
        permanent: true,
      )

      // call related dependencies
      ..put(
        CallHistoryObserver(
          callHistoryRepo: LocalCallHistoryRepo(
            callHistoryProvider: CallHistoryProvider(
                appDatabaseProvider: Get.find<AppDatabaseProvider>()),
          ),
          callStatusObserver: Get.find(),
          getContactByIdUseCase: GetContactByIdUseCase(
            contactRepository: Get.find(),
          ),
        ),
      )
      ..put<CallHistoryRepo>(
        LocalCallHistoryRepo(
          callHistoryProvider: CallHistoryProvider(
              appDatabaseProvider: Get.find<AppDatabaseProvider>()),
        ),
      )
      ..put(
        CallHistoryController(
          callHistoryRepo: LocalCallHistoryRepo(
            callHistoryProvider: CallHistoryProvider(
              appDatabaseProvider: Get.find<AppDatabaseProvider>(),
            ),
          ),
          contactNameUseCase: GetContactNameByIdUseCase(
            contactRepository: Get.find(),
          ),
          contactListenerUseCase: ContactListenerUseCase(
            contactRepository: Get.find(),
          ),
        ),
      );
  }
}
