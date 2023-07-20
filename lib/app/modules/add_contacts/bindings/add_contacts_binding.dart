import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/data/repository/contact_repository.dart';
import 'package:heyo/app/modules/shared/data/repository/db/cache_repository.dart';
import 'package:heyo/app/modules/shared/providers/database/app_database.dart';
import 'package:heyo/app/modules/shared/providers/database/dao/user_provider.dart';

import '../../calls/shared/data/providers/call_history/call_history_provider.dart';
import '../../calls/shared/data/repos/call_history/call_history_repo.dart';
import '../../chats/data/providers/chat_history/chat_history_provider.dart';
import '../../chats/data/repos/chat_history/chat_history_repo.dart';
import '../controllers/add_contacts_controller.dart';

class AddContactsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddContactsController>(
      () => AddContactsController(
          contactRepository: ContactRepository(
            cacheContractor: CacheRepository(
                userProvider: UserProvider(appDatabaseProvider: Get.find<AppDatabaseProvider>())),
          ),
          chatHistoryRepo: ChatHistoryLocalRepo(
            chatHistoryProvider: ChatHistoryProvider(
              appDatabaseProvider: Get.find(),
            ),
          ),
          callHistoryRepo: CallHistoryRepo(
              callHistoryProvider:
                  CallHistoryProvider(appDatabaseProvider: Get.find<AppDatabaseProvider>()))),
    );
  }
}
