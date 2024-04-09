import 'package:get/get.dart';
import 'package:heyo/core/di/injector_provider.dart';
import 'package:heyo/modules/call/data/web_rtc_call_repository.dart';
import 'package:heyo/modules/call/presentation/add_participate/add_participate_controller.dart';
import 'package:heyo/modules/features/contact/domain/contact_repo.dart';
import 'package:heyo/modules/features/contact/usecase/get_contacts_use_case.dart';

class AddParticipateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddParticipateController>(
      () => AddParticipateController(
        accountInfoRepo: Get.find(),
        callRepository: Get.find<WebRTCCallRepository>(),
        getContactsUserUseCase: GetContactsUseCase(
          contactRepository: inject.get<ContactRepo>(),
        ),
      ),
    );
  }
}
