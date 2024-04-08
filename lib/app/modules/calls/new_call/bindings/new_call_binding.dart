import 'package:get/get.dart';

import 'package:heyo/app/modules/calls/new_call/controllers/new_call_controller.dart';
import 'package:heyo/app/modules/calls/usecase/get_contact_user_use_case.dart';
import 'package:heyo/app/modules/shared/data/providers/database/app_database.dart';
import 'package:heyo/core/di/injector_provider.dart';
import 'package:heyo/modules/features/contact/data/local_contact_repo.dart';

class NewCallBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewCallController>(
      () => NewCallController(
        accountInfoRepo: Get.find(),
        contactRepository: LocalContactRepo(
          appDatabaseProvider: inject.get<AppDatabaseProvider>(),
        ),
        getContactUserUseCase: GetContactUserUseCase(
          contactRepository: LocalContactRepo(
            appDatabaseProvider: inject.get<AppDatabaseProvider>(),
          ),
        ),
      ),
    );
  }
}
