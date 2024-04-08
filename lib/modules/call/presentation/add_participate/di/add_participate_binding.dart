import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/usecase/get_contact_user_use_case.dart';
import 'package:heyo/core/di/injector_provider.dart';
import 'package:heyo/modules/call/data/web_rtc_call_repository.dart';
import 'package:heyo/modules/call/presentation/add_participate/add_participate_controller.dart';
import 'package:heyo/modules/features/contact/domain/contact_repo.dart';

class AddParticipateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddParticipateController>(
      () => AddParticipateController(
        accountInfoRepo: Get.find(),
        callRepository: Get.find<WebRTCCallRepository>(),
        getContactUserUseCase: GetContactUserUseCase(
          contactRepository: inject.get<ContactRepo>(),
        ),
      ),
    );
  }
}
