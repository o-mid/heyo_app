import 'package:heyo/app/modules/calls/shared/data/providers/call_history/call_history_abstract_provider.dart';
import 'package:heyo/app/modules/calls/shared/data/providers/call_history/call_history_provider.dart';
import 'package:heyo/app/modules/calls/shared/data/repos/call_history/call_history_abstract_repo.dart';
import 'package:heyo/app/modules/calls/shared/data/repos/call_history/call_history_repo.dart';
import 'package:heyo/app/modules/calls/usecase/contact_name_use_case.dart';
import 'package:heyo/app/modules/shared/controllers/call_history_observer.dart';
import 'package:heyo/core/di/injector_provider.dart';
import 'package:heyo/core/di/priority_injector_interface.dart';
import 'package:heyo/modules/call/data/call_requests_processor.dart';
import 'package:heyo/modules/call/data/call_status_observer.dart';
import 'package:heyo/modules/call/data/call_status_provider.dart';
import 'package:heyo/modules/call/data/ios_call_kit/ios_call_kit_provider.dart';
import 'package:heyo/modules/call/data/rtc/multiple_call_connection_handler.dart';
import 'package:heyo/modules/call/data/rtc/single_call_web_rtc_connection.dart';
import 'package:heyo/modules/call/data/signaling/call_signaling.dart';
import 'package:heyo/modules/call/data/web_rtc_call_repository.dart';
import 'package:heyo/modules/call/presentation/call_history/call_history_controller.dart';

class CallInjector with NormalPriorityInjector {
  @override
  void executeNormalPriorityInjector() {
    inject
      ..registerSingleton(
        CallSignaling(
          connectionContractor: inject.get(),
          notificationProvider: inject.get(),
        ),
      )
      ..registerSingleton(
        CallStatusProvider(callSignaling: inject.get()),
        //permanent: true,
      )
      ..registerSingleton(
        CallConnectionsHandler(
          callStatusProvider: inject.get(),
          singleCallWebRTCBuilder: SingleCallWebRTCBuilder(
            connectionContractor: inject.get(),
          ),
          callSignaling: inject.get(),
        ),
        //permanent: true,
      )
      ..registerSingleton<WebRTCCallRepository>(
        WebRTCCallRepository(
          callConnectionsHandler: inject.get<CallConnectionsHandler>(),
        ),
        //permanent: true,
      )
      ..registerSingleton(
        CallRequestsProcessor(
          connectionContractor: inject.get(),
          callStatusProvider: inject.get(),
          callConnectionsHandler: inject.get(),
        ),
        //permanent: true,
      )
      ..registerSingleton(
        CallKitProvider(
          accountInfoRepo: inject.get(),
          contactRepository: inject.get(),
          callRepository: inject.get<WebRTCCallRepository>(),
        ),
        //permanent: true,
      )
      ..registerSingleton(
        CallStatusObserver(
          callStatusProvider: inject.get(),
          accountInfoRepo: inject.get(),
          notificationsController: inject.get(),
          contactRepository: inject.get(),
          appLifeCycleController: inject.get(),
          iOSCallKitProvider: inject.get(),
        ),
        //permanent: true,
      )

      // call related dependencies
      ..registerSingleton<CallHistoryAbstractProvider>(
        CallHistoryProvider(appDatabaseProvider: inject.get()),
      )
      //..registerSingleton<CallHistoryRepo>(
      //  CallHistoryRepo(callHistoryProvider: inject.get()),
      //)
      ..registerSingleton<CallHistoryAbstractRepo>(
        CallHistoryRepo(callHistoryProvider: inject.get()),
      )
      ..registerSingleton(
        CallHistoryObserver(
          callHistoryRepo: inject.get(),
          callStatusObserver: inject.get(),
          contactRepository: inject.get(),
        ),
      )
      //..registerSingleton<AppDatabaseProvider>(AppDatabaseProvider())

      ..registerSingleton<ContactNameUseCase>(
        ContactNameUseCase(contactRepository: inject.get()),
      )
      ..registerSingleton(
        CallHistoryController(
          callHistoryRepo: inject.get(),
          contactNameUseCase: inject.get(),
          contactRepository: inject.get(),
        ),
      );
  }
}
