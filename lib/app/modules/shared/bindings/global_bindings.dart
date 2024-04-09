import 'package:get/get.dart';
import 'package:heyo/modules/features/call_history/domain/call_history_repo.dart';
import 'package:heyo/app/modules/chats/data/repos/chat_history/chat_history_abstract_repo.dart';
import 'package:heyo/app/modules/shared/bindings/account_bindings.dart';
import 'package:heyo/app/modules/shared/bindings/application_bindings.dart';
import 'package:heyo/app/modules/shared/bindings/call_bindings.dart';
import 'package:heyo/app/modules/shared/bindings/messaging_bindings.dart';
import 'package:heyo/app/modules/shared/bindings/notification_bindings.dart';
import 'package:heyo/app/modules/shared/bindings/p2p_bindings.dart';
import 'package:heyo/app/modules/shared/controllers/live_location_controller.dart';
import 'package:heyo/app/modules/shared/controllers/user_preview_controller.dart';
import 'package:heyo/modules/features/contact/data/local_contact_repo.dart';
import 'package:heyo/modules/features/contact/usecase/delete_contacts_use_case.dart';
import 'package:heyo/modules/features/contact/usecase/get_contact_by_id_use_case.dart';

class GlobalBindings extends Bindings {
  @override
  void dependencies() {
    ApplicationBindings().executeNormalPriorityBindings();
    AccountBindings().executeNormalPriorityBindings();
    P2PBindings().executeNormalPriorityBindings();
    NotificationBindings().executeNormalPriorityBindings();
    CallBindings().executeNormalPriorityBindings();
    MessagingBindings().executeNormalPriorityBindings();

    Get
      ..put(LiveLocationController())
      ..put(UserPreviewController(
        deleteContactsUseCase: DeleteContactsUseCase(
          contactRepository: Get.find<LocalContactRepo>(),
        ),
        getContactByIdUseCase: GetContactByIdUseCase(
          contactRepository: Get.find<LocalContactRepo>(),
        ),
        callHistoryRepo: Get.find<CallHistoryRepo>(),
        chatHistoryRepo: Get.find<ChatHistoryLocalAbstractRepo>(),
      ));
  }
}
