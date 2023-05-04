import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/data/repository/contact_repository.dart';
import 'package:heyo/app/modules/shared/data/repository/db/cache_repository.dart';
import 'package:heyo/app/modules/shared/providers/database/app_database.dart';
import 'package:heyo/app/modules/shared/providers/database/dao/user_provider.dart';

import '../controllers/contacts_controller.dart';

class ContactsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContactsController>(
      () => ContactsController(
        contactRepo: ContactRepository(
          cacheContractor: CacheRepository(
              userContact: UserProvider(appDatabaseProvider: Get.find<AppDatabaseProvider>())),
        ),
      ),
    );
  }
}
