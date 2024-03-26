import 'package:get/get.dart';
import 'package:heyo/app/modules/chats/controllers/chats_controller.dart';
import 'package:heyo/app/modules/chats/data/providers/chat_history/chat_history_provider.dart';
import 'package:heyo/modules/features/chats/domain/chat_history_repo.dart';
import 'package:heyo/modules/features/chats/data/local_chat_history_repo.dart';
import 'package:heyo/app/modules/messages/connection/connection_data_handler.dart';
import 'package:heyo/app/modules/messages/connection/connection_repo.dart';
import 'package:heyo/app/modules/messages/connection/data/data_channel_messaging_connection.dart';
import 'package:heyo/app/modules/messages/connection/data/received_messaging_data_processor.dart';
import 'package:heyo/app/modules/messages/connection/data/wifi_direct_messaging_connection.dart';
import 'package:heyo/app/modules/messages/connection/rtc_connection_repo.dart';
import 'package:heyo/app/modules/messages/connection/sync_messages.dart';
import 'package:heyo/app/modules/messages/data/message_processor.dart';
import 'package:heyo/app/modules/messages/data/provider/messages_provider.dart';
import 'package:heyo/app/modules/messages/data/repo/messages_abstract_repo.dart';
import 'package:heyo/app/modules/messages/data/repo/messages_repo.dart';
import 'package:heyo/app/modules/messages/data/usecases/send_message_usecase.dart';
import 'package:heyo/app/modules/notifications/controllers/notifications_controller.dart';
import 'package:heyo/app/modules/shared/bindings/priority_bindings_interface.dart';
import 'package:heyo/app/modules/shared/controllers/audio_message_controller.dart';
import 'package:heyo/app/modules/shared/controllers/global_message_controller.dart';
import 'package:heyo/app/modules/shared/controllers/video_message_controller.dart';
import 'package:heyo/app/modules/shared/data/providers/database/app_database.dart';
import 'package:heyo/app/modules/shared/data/repository/contact_repository.dart';

class MessagingBindings with NormalPriorityBindings, HighPriorityBindings {
  @override
  void executeNormalPriorityBindings() {
    Get
      ..put(
        DataHandler(
          messagesRepo: MessagesRepo(
            messagesProvider: MessagesProvider(
              appDatabaseProvider: Get.find<AppDatabaseProvider>(),
            ),
          ),
          chatHistoryRepo: Get.find(),
          notificationsController: Get.find(),
          contactRepository: Get.find(),
          accountInfoRepo: Get.find(),
        ),
        permanent: true,
      )
      ..put<MessagesAbstractRepo>(
        MessagesRepo(
          messagesProvider: MessagesProvider(appDatabaseProvider: Get.find<AppDatabaseProvider>()),
        ),
      )
      ..put(
        ChatsController(
          chatHistoryRepo: Get.find(),
          messagesRepo: MessagesRepo(
            messagesProvider:
                MessagesProvider(appDatabaseProvider: Get.find<AppDatabaseProvider>()),
          ),
          contactRepository: Get.find<ContactRepository>(),
        ),
      )
      ..put(GlobalMessageController())
      ..put(AudioMessageController())
      ..put(VideoMessageController())
      ..put(DataChannelMessagingConnection(multipleConnectionHandler: Get.find()))
      ..put(
        RTCMessagingConnectionRepository(
          dataHandler: Get.find(),
          dataChannelMessagingConnection: Get.find(),
        ),
      )
      ..put<ConnectionRepository>(
        RTCMessagingConnectionRepository(
          dataHandler: Get.find(),
          dataChannelMessagingConnection: Get.find(),
        ),
      )
      ..put(
        WifiDirectMessagingConnection(),
      )
      ..put(
        ReceivedMessageDataProcessor(
          dataChannelMessagingConnection: Get.find(),
          dataHandler: Get.find(),
        ),
      )
      ..put(
        Get.put(
          SyncMessages(
            p2pState: Get.find(),
            multipleConnectionHandler: Get.find(),
            accountInfo: Get.find(),
            chatHistoryRepo: Get.find(),
            messagesRepo: MessagesRepo(
              messagesProvider:
                  MessagesProvider(appDatabaseProvider: Get.find<AppDatabaseProvider>()),
            ),
            sendMessageUseCase: SendMessageUseCase(
              messagesRepo: MessagesRepo(
                messagesProvider:
                    MessagesProvider(appDatabaseProvider: Get.find<AppDatabaseProvider>()),
              ),
              connectionRepository: Get.find<RTCMessagingConnectionRepository>(),
              processor: MessageProcessor(),
            ),
          ),
        ),
      );
  }

  @override
  void executeHighPriorityBindings() {
    Get.put<ChatHistoryRepo>(
      LocalChatHistoryRepo(
        chatHistoryProvider: ChatHistoryProvider(
          appDatabaseProvider: Get.find(),
        ),
      ),
    );
  }
}
