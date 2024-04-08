import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/main/controllers/call_controller.dart';
import 'package:heyo/app/modules/calls/usecase/contact_availability_use_case.dart';
import 'package:heyo/app/modules/calls/usecase/get_contact_user_use_case.dart';
import 'package:heyo/core/di/injector_provider.dart';
import 'package:heyo/modules/call/data/web_rtc_call_repository.dart';
import 'package:heyo/modules/features/contact/domain/contact_repo.dart';

class CallBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CallController>(
      () => CallController(
        callRepository: Get.find<WebRTCCallRepository>(),
        accountInfo: Get.find(),
        getContactUserUseCase: GetContactUserUseCase(
          contactRepository: inject.get<ContactRepo>(),
        ),
        contactAvailabilityUseCase: ContactAvailabilityUseCase(
          contactRepository: inject.get<ContactRepo>(),
        ),
        iOSCallKitProvider: Get.find(),
      ),
    );
  }
}
