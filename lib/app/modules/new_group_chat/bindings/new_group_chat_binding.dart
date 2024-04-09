import 'package:get/get.dart';
import 'package:heyo/app/modules/new_group_chat/controllers/new_group_chat_controller.dart';
import 'package:heyo/core/di/injector_provider.dart';
import 'package:heyo/modules/features/contact/domain/contact_repo.dart';
import 'package:heyo/modules/features/contact/usecase/add_contacts_use_case.dart';
import 'package:heyo/modules/features/contact/usecase/contact_listener_use_case.dart';
import 'package:heyo/modules/features/contact/usecase/delete_contact_use_case.dart';
import 'package:heyo/modules/features/contact/usecase/get_contact_by_id_use_case.dart';
import 'package:heyo/modules/features/contact/usecase/serach_contacts_use_case.dart';

class NewGroupChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewGroupChatController>(
      () => NewGroupChatController(
        accountInfoRepo: Get.find(),
        addContactUseCase: AddContactUseCase(
          contactRepository: inject.get<ContactRepo>(),
        ),
        contactListenerUseCase: ContactListenerUseCase(
          contactRepository: inject.get<ContactRepo>(),
        ),
        deleteContactUseCase: DeleteContactUseCase(
          contactRepository: inject.get<ContactRepo>(),
        ),
        getContactByIdUseCase: GetContactByIdUseCase(
          contactRepository: inject.get<ContactRepo>(),
        ),
        searchContactsUseCase: SearchContactsUseCase(
          contactRepository: inject.get<ContactRepo>(),
        ),
      ),
    );
  }
}
