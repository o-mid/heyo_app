import 'package:get/get.dart';
import 'package:heyo/app/modules/new_chat/controllers/new_chat_controller.dart';
import 'package:heyo/core/di/injector_provider.dart';
import 'package:heyo/modules/features/contact/domain/contact_repo.dart';

class NewChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewChatController>(
      () => NewChatController(
        accountInfoRepo: Get.find(),
        contactRepository: inject.get<ContactRepo>(),
      ),
    );
  }
}
