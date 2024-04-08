import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/usecase/contact_availability_use_case.dart';
import 'package:heyo/app/modules/shared/data/providers/database/app_database.dart';
import 'package:heyo/core/di/injector_provider.dart';
import 'package:heyo/modules/call/data/web_rtc_call_repository.dart';
import 'package:heyo/modules/call/presentation/incoming_call/incoming_call_controller.dart';
import 'package:heyo/modules/features/contact/data/local_contact_repo.dart';

class IncomingCallBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IncomingCallController>(
      () => IncomingCallController(
        callRepository: Get.find<WebRTCCallRepository>(),
        p2pState: Get.find(),
        contactAvailabilityUseCase: ContactAvailabilityUseCase(
          contactRepository: LocalContactRepo(
            appDatabaseProvider: inject.get<AppDatabaseProvider>(),
          ),
        ),
      ),
    );
  }
}
