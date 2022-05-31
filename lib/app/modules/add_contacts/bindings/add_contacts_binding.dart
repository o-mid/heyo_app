import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/data/repository/contact_repository.dart';
import 'package:heyo/app/modules/shared/data/repository/db/cache_repository.dart';
import 'package:heyo/app/modules/shared/providers/database/dao/user_contact_dao.dart';

import '../controllers/add_contacts_controller.dart';

class AddContactsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddContactsController>(
      () => AddContactsController(
          contactRepository: ContactRepository(
              cacheContractor:
                  CacheRepository(userContact: UserContactProvider()))),
    );
  }
}
