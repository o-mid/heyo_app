import 'package:get/get.dart';

import 'package:heyo/app/modules/messages/data/repo/messages_abstract_repo.dart';
import 'package:heyo/core/di/injector_provider.dart';
import 'package:heyo/modules/features/chats/domain/chat_history_repo.dart';
import 'package:heyo/modules/features/contact/domain/contact_repo.dart';
import 'package:heyo/modules/features/contact/presentation/controllers/add_contact_controller.dart';

class AddContactsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddContactsController>(
      () => AddContactsController(
        contactRepo: inject.get<ContactRepo>(),
        chatHistoryRepo: inject.get<ChatHistoryRepo>(),
        messagesRepo: inject.get<MessagesAbstractRepo>(),
      ),
    );
  }
}
