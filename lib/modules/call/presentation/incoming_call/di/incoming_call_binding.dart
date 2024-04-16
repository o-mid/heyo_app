import 'package:get/get.dart';
import 'package:heyo/core/di/injector_provider.dart';
import 'package:heyo/modules/call/data/web_rtc_call_repository.dart';
import 'package:heyo/modules/call/presentation/incoming_call/incoming_call_controller.dart';
import 'package:heyo/modules/features/contact/domain/contact_repo.dart';
import 'package:heyo/modules/features/contact/usecase/get_contact_by_id_use_case.dart';

class IncomingCallBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IncomingCallController>(
      () => IncomingCallController(
        callRepository: Get.find<WebRTCCallRepository>(),
        p2pState: Get.find(),
        getContactByIdUseCase: GetContactByIdUseCase(
          contactRepository: inject.get<ContactRepo>(),
        ),
      ),
    );
  }
}
