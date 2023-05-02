import 'package:get/get.dart';
import 'package:heyo/app/modules/chats/data/repos/chat_history/chat_history_repo.dart';
import 'package:heyo/app/modules/messages/data/provider/messages_provider.dart';
import 'package:heyo/app/modules/messages/data/repo/messages_repo.dart';

import '../../chats/data/providers/chat_history/chat_history_provider.dart';
import '../../messaging/controllers/messaging_connection_controller.dart';

import '../controllers/messages_controller.dart';

class MessagesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MessagesController>(() => MessagesController(
          messagesRepo: MessagesRepo(
            messagesProvider: MessagesProvider(
              appDatabaseProvider: Get.find(),
            ),
          ),
          messagingConnection: Get.find<MessagingConnectionController>(),
          chatHistoryRepo: ChatHistoryLocalRepo(
            chatHistoryProvider: ChatHistoryProvider(
              appDatabaseProvider: Get.find(),
            ),
          ),
        ));
  }
}
