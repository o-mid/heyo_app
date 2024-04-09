import 'package:get/get.dart';
import 'package:heyo/app/modules/new_chat/controllers/new_chat_controller.dart';
import 'package:heyo/core/di/injector_provider.dart';
import 'package:heyo/modules/features/contact/domain/contact_repo.dart';
import 'package:heyo/modules/features/contact/usecase/contact_listener_use_case.dart';
import 'package:heyo/modules/features/contact/usecase/serach_contacts_use_case.dart';

class NewChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewChatController>(
      () => NewChatController(
        accountInfoRepo: Get.find(),
        contactListenerUseCase: ContactListenerUseCase(
          contactRepository: inject.get<ContactRepo>(),
        ),
        searchContactsUseCase: SearchContactsUseCase(
          contactRepository: inject.get<ContactRepo>(),
        ),
      ),
    );
  }
}
