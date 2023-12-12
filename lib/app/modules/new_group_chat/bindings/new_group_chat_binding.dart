import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/bindings/global_bindings.dart';
import 'package:heyo/app/modules/shared/data/repository/contact_repository.dart';
import 'package:heyo/app/modules/shared/data/repository/db/cache_repository.dart';
import 'package:heyo/app/modules/shared/providers/database/app_database.dart';
import 'package:heyo/app/modules/shared/providers/database/dao/user_provider.dart';
import '../controllers/new_group_chat_controller.dart';

class NewGroupChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewGroupChatController>(
      () => NewGroupChatController(
        accountInfoRepo: Get.find(),
        contactRepository: ContactRepository(
          cacheContractor: CacheRepository(
            userProvider: UserProvider(appDatabaseProvider: Get.find<AppDatabaseProvider>()),
          ),
        ),
      ),
    );
  }
}
