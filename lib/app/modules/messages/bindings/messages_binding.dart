import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/data/provider/messages_provider.dart';
import 'package:heyo/app/modules/messages/data/repo/messages_repo.dart';

import '../controllers/messages_controller.dart';

class MessagesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MessagesController>(
      () => MessagesController(
        messagesRepo: MessagesRepo(
          messagesProvider: MessagesProvider(
            appDatabaseProvider: Get.find(),
          ),
        ),
      ),
    );
  }
}
