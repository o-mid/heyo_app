import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/usecase/contact_availability_use_case.dart';
import 'package:heyo/core/di/injector_provider.dart';
import 'package:heyo/modules/call/data/web_rtc_call_repository.dart';
import 'package:heyo/modules/call/presentation/incoming_call/incoming_call_controller.dart';
import 'package:heyo/modules/features/contact/domain/contact_repo.dart';

class IncomingCallBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IncomingCallController>(
      () => IncomingCallController(
        callRepository: Get.find<WebRTCCallRepository>(),
        p2pState: Get.find(),
        contactAvailabilityUseCase: ContactAvailabilityUseCase(
          contactRepository: inject.get<ContactRepo>(),
        ),
      ),
    );
  }
}
