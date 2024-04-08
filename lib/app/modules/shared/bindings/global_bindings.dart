import 'package:get/get.dart';
import 'package:heyo/modules/features/call_history/domain/call_history_repo.dart';
import 'package:heyo/modules/features/chats/domain/chat_history_repo.dart';
import 'package:heyo/app/modules/shared/bindings/account_bindings.dart';
import 'package:heyo/app/modules/shared/bindings/application_bindings.dart';
import 'package:heyo/app/modules/shared/bindings/call_bindings.dart';
import 'package:heyo/app/modules/shared/bindings/messaging_bindings.dart';
import 'package:heyo/app/modules/shared/bindings/notification_bindings.dart';
import 'package:heyo/app/modules/shared/bindings/p2p_bindings.dart';
import 'package:heyo/app/modules/shared/controllers/live_location_controller.dart';
import 'package:heyo/app/modules/shared/controllers/user_preview_controller.dart';
import 'package:heyo/modules/features/contact/data/local_contact_repo.dart';

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
        contactRepository: Get.find<LocalContactRepo>(),
        callHistoryRepo: Get.find<CallHistoryRepo>(),
        chatHistoryRepo: Get.find<ChatHistoryRepo>(),
      ));
  }
}
