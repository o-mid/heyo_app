import 'package:get/get.dart';
import 'package:heyo/app/modules/add_contacts/controllers/add_contacts_controller.dart';
import 'package:heyo/app/modules/calls/shared/data/providers/call_history/call_history_provider.dart';
import 'package:heyo/modules/features/call_history/data/local_call_history_repo.dart';
import 'package:heyo/app/modules/chats/data/providers/chat_history/chat_history_provider.dart';
import 'package:heyo/modules/features/chats/data/local_chat_history_repo.dart';
import 'package:heyo/app/modules/shared/data/repository/contact_repository.dart';
import 'package:heyo/app/modules/shared/data/repository/db/cache_repository.dart';
import 'package:heyo/app/modules/shared/data/providers/database/app_database.dart';
import 'package:heyo/app/modules/shared/data/providers/database/dao/user_provider.dart';

import '../../messages/data/provider/messages_provider.dart';
import '../../messages/data/repo/messages_repo.dart';

class AddContactsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddContactsController>(
      () => AddContactsController(
        contactRepository: ContactRepository(
          cacheContractor: CacheRepository(
            userProvider: UserProvider(
              appDatabaseProvider: Get.find<AppDatabaseProvider>(),
            ),
          ),
        ),
        chatHistoryRepo: Get.find(),
        callHistoryRepo: LocalCallHistoryRepo(
          callHistoryProvider: CallHistoryProvider(
            appDatabaseProvider: Get.find<AppDatabaseProvider>(),
          ),
        ),
        messagesRepo: MessagesRepo(
          messagesProvider: MessagesProvider(
            appDatabaseProvider: Get.find(),
          ),
        ),
      ),
    );
  }
}
