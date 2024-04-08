import 'package:get/get.dart';
import 'package:heyo/app/modules/new_group_chat/controllers/new_group_chat_controller.dart';
import 'package:heyo/core/di/injector_provider.dart';
import 'package:heyo/modules/features/contact/domain/contact_repo.dart';

class NewGroupChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewGroupChatController>(
      () => NewGroupChatController(
        accountInfoRepo: Get.find(),
        contactRepository: inject.get<ContactRepo>(),
      ),
    );
  }
}
