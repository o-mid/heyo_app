import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/call_history/controllers/call_history_controller.dart';
import 'package:heyo/app/modules/calls/data/call_requests_processor.dart';
import 'package:heyo/app/modules/calls/data/call_status_observer.dart';
import 'package:heyo/app/modules/calls/data/call_status_provider.dart';
import 'package:heyo/app/modules/calls/data/ios_call_kit/ios_call_kit_provider.dart';
import 'package:heyo/app/modules/calls/data/rtc/multiple_call_connection_handler.dart';
import 'package:heyo/app/modules/calls/data/rtc/single_call_web_rtc_connection.dart';
import 'package:heyo/app/modules/calls/data/signaling/call_signaling.dart';
import 'package:heyo/app/modules/calls/data/web_rtc_call_repository.dart';
import 'package:heyo/app/modules/calls/shared/data/providers/call_history/call_history_provider.dart';
import 'package:heyo/app/modules/calls/shared/data/repos/call_history/call_history_abstract_repo.dart';
import 'package:heyo/app/modules/calls/shared/data/repos/call_history/call_history_repo.dart';
import 'package:heyo/app/modules/calls/usecase/contact_name_use_case.dart';
import 'package:heyo/app/modules/shared/bindings/priority_bindings_interface.dart';
import 'package:heyo/app/modules/shared/controllers/call_history_observer.dart';
import 'package:heyo/app/modules/shared/data/providers/database/app_database.dart';
import 'package:heyo/app/modules/shared/data/providers/database/dao/user_provider.dart';
import 'package:heyo/app/modules/shared/data/repository/contact_repository.dart';
import 'package:heyo/app/modules/shared/data/repository/db/cache_repository.dart';

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
          contactRepository: Get.find(),
          callRepository: Get.find<WebRTCCallRepository>(),
        ),
        permanent: true,
      )
      ..put(
        CallStatusObserver(
            callStatusProvider: Get.find(),
            accountInfoRepo: Get.find(),
            notificationsController: Get.find(),
            contactRepository: Get.find(),
            appLifeCycleController: Get.find(),
            iOSCallKitProvider: Get.find()),
        permanent: true,
      )

      // call related dependencies
      ..put(
        CallHistoryObserver(
          callHistoryRepo: CallHistoryRepo(
            callHistoryProvider: CallHistoryProvider(
                appDatabaseProvider: Get.find<AppDatabaseProvider>()),
          ),
          callStatusObserver: Get.find(),
          contactRepository: Get.find(),
        ),
      )
      ..put<CallHistoryAbstractRepo>(
        CallHistoryRepo(
          callHistoryProvider: CallHistoryProvider(
              appDatabaseProvider: Get.find<AppDatabaseProvider>()),
        ),
      )
      ..put(
        CallHistoryController(
          callHistoryRepo: CallHistoryRepo(
            callHistoryProvider: CallHistoryProvider(
              appDatabaseProvider: Get.find<AppDatabaseProvider>(),
            ),
          ),
          contactNameUseCase: ContactNameUseCase(
            contactRepository: Get.find(),
          ),
          contactRepository: Get.find(),
        ),
      );
  }
}
