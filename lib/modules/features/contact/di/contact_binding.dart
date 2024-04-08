import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/data/providers/database/app_database.dart';
import 'package:heyo/core/di/injector_provider.dart';
import 'package:heyo/modules/features/contact/data/local_contact_repo.dart';
import 'package:heyo/modules/features/contact/presentation/controllers/contact_controller.dart';

class ContactsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContactController>(
      () => ContactController(
        contactRepo: LocalContactRepo(
          appDatabaseProvider: inject.get<AppDatabaseProvider>(),
        ),
      ),
    );
  }
}
