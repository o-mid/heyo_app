import 'package:get_it/get_it.dart';
import 'package:heyo/modules/features/call_history/domain/call_history_repo.dart';
import 'package:heyo/modules/features/chats/domain/chat_history_repo.dart';
import 'package:heyo/app/modules/shared/controllers/live_location_controller.dart';
import 'package:heyo/app/modules/shared/controllers/user_preview_controller.dart';
import 'package:heyo/modules/features/contact/data/local_contact_repo.dart';
import 'package:heyo/core/di/account_injector.dart';
import 'package:heyo/core/di/application_injector.dart';
import 'package:heyo/core/di/call_injector.dart';
import 'package:heyo/core/di/messaging_injector.dart';
import 'package:heyo/core/di/network_injector.dart';
import 'package:heyo/core/di/notification_injector.dart';
import 'package:heyo/core/di/p2p_injector.dart';
import 'package:heyo/core/di/storage_injector.dart';
import 'package:heyo/modules/features/contact/domain/contact_repo.dart';
import 'package:heyo/modules/features/contact/usecase/delete_contact_use_case.dart';
import 'package:heyo/modules/features/contact/usecase/get_contact_by_id_use_case.dart';

final GetIt inject = GetIt.instance;

Future<void> setupInjection() async {
  StorageInjector().executeHighPriorityInjector();
  AccountInjector().executeHighPriorityInjector();
  P2PInjector().executeHighPriorityInjector();
  NetworkInjector().executeHighPriorityInjector();
  MessagingInjector().executeHighPriorityInjector();

  ApplicationInjector().executeNormalPriorityInjector();
  AccountInjector().executeNormalPriorityInjector();
  P2PInjector().executeNormalPriorityInjector();
  NotificationInjector().executeNormalPriorityInjector();
  CallInjector().executeNormalPriorityInjector();
  MessagingInjector().executeNormalPriorityInjector();

  inject
    ..registerSingleton(LiveLocationController())
    ..registerSingleton(
      UserPreviewController(
        getContactByIdUseCase: GetContactByIdUseCase(
          contactRepository: inject.get<ContactRepo>(),
        ),
        deleteContactsUseCase: DeleteContactUseCase(
          contactRepository: inject.get<ContactRepo>(),
        ),
        callHistoryRepo: inject.get<CallHistoryRepo>(),
        chatHistoryRepo: inject.get<ChatHistoryRepo>(),
      ),
    );
}
