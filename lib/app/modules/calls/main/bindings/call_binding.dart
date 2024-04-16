import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/main/controllers/call_controller.dart';
import 'package:heyo/core/di/injector_provider.dart';
import 'package:heyo/modules/call/data/web_rtc_call_repository.dart';
import 'package:heyo/modules/features/contact/domain/contact_repo.dart';
import 'package:heyo/modules/features/contact/usecase/get_contact_name_by_id_use_case.dart';

class CallBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CallController>(
      () => CallController(
        callRepository: Get.find<WebRTCCallRepository>(),
        accountInfo: Get.find(),
        getContactNameByIdUseCase: GetContactNameByIdUseCase(
          contactRepository: inject.get<ContactRepo>(),
        ),
        iOSCallKitProvider: Get.find(),
      ),
    );
  }
}
