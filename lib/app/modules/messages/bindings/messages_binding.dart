import 'package:get/get.dart';
import 'package:heyo/app/modules/chats/data/repos/chat_history/chat_history_repo.dart';
import 'package:heyo/app/modules/messages/data/provider/messages_provider.dart';
import 'package:heyo/app/modules/messages/data/repo/messages_repo.dart';
import 'package:heyo/app/modules/messages/data/connection_message_repository_impl.dart';
import 'package:heyo/app/modules/messages/data/user_state_repository_Impl.dart';

import '../../chats/data/providers/chat_history/chat_history_provider.dart';
import '../controllers/messages_controller.dart';

class MessagesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MessagesController>(
      () => MessagesController(
        messageRepository: ConnectionMessageRepositoryImpl(
          messagesRepo: MessagesRepo(
            messagesProvider: MessagesProvider(
              appDatabaseProvider: Get.find(),
            ),
          ),
        ),
        userStateRepository: UserStateRepositoryImpl(
          contactRepository: Get.find(),
          messagesRepo: MessagesRepo(
            messagesProvider: MessagesProvider(
              appDatabaseProvider: Get.find(),
            ),
          ),
          chatHistoryRepo: ChatHistoryLocalRepo(
            chatHistoryProvider: ChatHistoryProvider(
              appDatabaseProvider: Get.find(),
            ),
          ),
        ),
      ),
    );
  }
}
