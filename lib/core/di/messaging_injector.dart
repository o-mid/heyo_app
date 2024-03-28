import 'package:heyo/app/modules/chats/controllers/chats_controller.dart';
import 'package:heyo/app/modules/chats/data/providers/chat_history/chat_history_provider.dart';
import 'package:heyo/app/modules/chats/data/repos/chat_history/chat_history_abstract_repo.dart';
import 'package:heyo/app/modules/chats/data/repos/chat_history/chat_history_repo.dart';
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
import 'package:heyo/app/modules/shared/controllers/audio_message_controller.dart';
import 'package:heyo/app/modules/shared/controllers/global_message_controller.dart';
import 'package:heyo/app/modules/shared/controllers/video_message_controller.dart';
import 'package:heyo/app/modules/shared/data/providers/database/app_database.dart';
import 'package:heyo/modules/features/contact/data/local_contact_repo.dart';
import 'package:heyo/core/di/injector_provider.dart';
import 'package:heyo/core/di/priority_injector_interface.dart';

class MessagingInjector with NormalPriorityInjector, HighPriorityInjector {
  @override
  void executeNormalPriorityInjector() {
    inject
      ..registerSingleton(
        DataHandler(
          messagesRepo: MessagesRepo(
            messagesProvider: MessagesProvider(
              appDatabaseProvider: inject.get<AppDatabaseProvider>(),
            ),
          ),
          chatHistoryRepo: inject.get(),
          notificationsController: inject.get(),
          contactRepository: inject.get(),
          accountInfoRepo: inject.get(),
        ),
        //permanent: true,
      )
      ..registerSingleton<MessagesAbstractRepo>(
        MessagesRepo(
          messagesProvider: MessagesProvider(
            appDatabaseProvider: inject.get<AppDatabaseProvider>(),
          ),
        ),
      )
      ..registerSingleton(
        ChatsController(
          chatHistoryRepo: inject.get(),
          messagesRepo: MessagesRepo(
            messagesProvider: MessagesProvider(
              appDatabaseProvider: inject.get<AppDatabaseProvider>(),
            ),
          ),
          contactRepository: inject.get<LocalContactRepo>(),
        ),
      )
      ..registerSingleton(GlobalMessageController())
      ..registerSingleton(AudioMessageController())
      ..registerSingleton(VideoMessageController())
      ..registerSingleton(
        DataChannelMessagingConnection(multipleConnectionHandler: inject.get()),
      )
      ..registerSingleton(
        RTCMessagingConnectionRepository(
          dataHandler: inject.get(),
          dataChannelMessagingConnection: inject.get(),
        ),
      )
      ..registerSingleton<ConnectionRepository>(
        RTCMessagingConnectionRepository(
          dataHandler: inject.get(),
          dataChannelMessagingConnection: inject.get(),
        ),
      )
      ..registerSingleton(
        WifiDirectMessagingConnection(),
      )
      ..registerSingleton(
        ReceivedMessageDataProcessor(
          dataChannelMessagingConnection: inject.get(),
          dataHandler: inject.get(),
        ),
      )
      ..registerSingleton(
        SyncMessages(
          p2pState: inject.get(),
          multipleConnectionHandler: inject.get(),
          accountInfo: inject.get(),
          chatHistoryRepo: inject.get(),
          messagesRepo: MessagesRepo(
            messagesProvider: MessagesProvider(
              appDatabaseProvider: inject.get<AppDatabaseProvider>(),
            ),
          ),
          sendMessageUseCase: SendMessageUseCase(
            messagesRepo: MessagesRepo(
              messagesProvider: MessagesProvider(
                appDatabaseProvider: inject.get<AppDatabaseProvider>(),
              ),
            ),
            connectionRepository:
                inject.get<RTCMessagingConnectionRepository>(),
            processor: MessageProcessor(),
          ),
        ),
      );
  }

  @override
  void executeHighPriorityInjector() {
    inject.registerSingleton<ChatHistoryLocalAbstractRepo>(
      ChatHistoryLocalRepo(
        chatHistoryProvider: ChatHistoryProvider(
          appDatabaseProvider: inject.get(),
        ),
      ),
    );
  }
}
