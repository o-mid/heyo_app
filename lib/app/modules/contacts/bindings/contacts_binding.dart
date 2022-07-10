import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/data/repository/contact_repository.dart';
import 'package:heyo/app/modules/shared/data/repository/db/cache_repository.dart';
import 'package:heyo/app/modules/shared/providers/database/dao/user_contact_provider.dart';

import '../controllers/contacts_controller.dart';

class ContactsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContactsController>(
      () => ContactsController(
        contactRepo: ContactRepository(
          cacheContractor: CacheRepository(userContact: UserContactProvider()),
        ),
      ),
    );
  }
}
