import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/shared/data/repos/call_history/call_history_abstract_repo.dart';
import 'package:heyo/app/modules/chats/data/repos/chat_history/chat_history_abstract_repo.dart';
import 'package:heyo/app/modules/chats/data/repos/chat_history/chat_history_repo.dart';
import 'package:heyo/app/modules/shared/bindings/account_bindings.dart';
import 'package:heyo/app/modules/shared/bindings/application_bindings.dart';
import 'package:heyo/app/modules/shared/bindings/call_bindings.dart';
import 'package:heyo/app/modules/shared/bindings/messaging_bindings.dart';
import 'package:heyo/app/modules/shared/bindings/notification_bindings.dart';
import 'package:heyo/app/modules/shared/bindings/p2p_bindings.dart';
import 'package:heyo/app/modules/shared/bindings/repository_bindings.dart';
import 'package:heyo/app/modules/shared/controllers/app_lifecyle_controller.dart';
import 'package:heyo/app/modules/shared/controllers/live_location_controller.dart';
import 'package:heyo/app/modules/shared/controllers/user_preview_controller.dart';
import 'package:heyo/app/modules/shared/data/providers/database/app_database.dart';
import 'package:heyo/app/modules/shared/data/providers/database/dao/user_provider.dart';
import 'package:heyo/app/modules/shared/data/repository/contact_repository.dart';
import 'package:heyo/app/modules/shared/data/repository/db/cache_repository.dart';

class GlobalBindings extends Bindings {
  @override
  void dependencies() {
    ApplicationBindings().executeNormalPriorityBindings();
    RepositoryBindings().executeNormalPriorityBindings();
    AccountBindings().executeNormalPriorityBindings();
    P2PBindings().executeNormalPriorityBindings();
    NotificationBindings().executeNormalPriorityBindings();
    CallBindings().executeNormalPriorityBindings();
    MessagingBindings().executeNormalPriorityBindings();

    Get
      ..put(LiveLocationController())
      ..put(
        UserPreviewController(
          contactRepository: Get.find<ContactRepository>(),
          callHistoryRepo: Get.find<CallHistoryAbstractRepo>(),
          chatHistoryRepo: Get.find<ChatHistoryLocalAbstractRepo>(),
        ),
      );
  }
}
