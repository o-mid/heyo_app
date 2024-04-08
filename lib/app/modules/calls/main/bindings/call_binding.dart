import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/main/controllers/call_controller.dart';
import 'package:heyo/app/modules/calls/usecase/contact_availability_use_case.dart';
import 'package:heyo/app/modules/calls/usecase/get_contact_user_use_case.dart';
import 'package:heyo/app/modules/shared/data/providers/database/app_database.dart';
import 'package:heyo/app/modules/shared/data/providers/database/dao/user_provider.dart';
import 'package:heyo/core/di/injector_provider.dart';
import 'package:heyo/modules/features/contact/data/local_contact_repo.dart';
import 'package:heyo/app/modules/shared/data/repository/db/cache_repository.dart';
import 'package:heyo/modules/call/data/web_rtc_call_repository.dart';

import '../../../../../modules/call/data/ios_call_kit/ios_call_kit_provider.dart';

class CallBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CallController>(
      () => CallController(
        callRepository: Get.find<WebRTCCallRepository>(),
        accountInfo: Get.find(),
        getContactUserUseCase: GetContactUserUseCase(
          contactRepository: LocalContactRepo(
            appDatabaseProvider: inject.get<AppDatabaseProvider>(),
          ),
        ),
        contactAvailabilityUseCase: ContactAvailabilityUseCase(
          contactRepository: LocalContactRepo(
            appDatabaseProvider: inject.get<AppDatabaseProvider>(),
          ),
        ),
        iOSCallKitProvider: Get.find(),
      ),
    );
  }
}
