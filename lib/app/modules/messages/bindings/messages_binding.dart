import 'package:get/get.dart';
import 'package:heyo/app/modules/chats/data/repos/chat_history/chat_history_repo.dart';
import 'package:heyo/app/modules/messages/data/provider/messages_provider.dart';
import 'package:heyo/app/modules/messages/data/repo/messages_repo.dart';
import 'package:heyo/app/modules/messages/data/connection_message_repository_impl.dart';
import 'package:heyo/app/modules/messages/data/usecases/init_message_usecase.dart';
import 'package:heyo/app/modules/messages/data/usecases/read_message_usecase.dart';
import 'package:heyo/app/modules/messages/data/user_state_repository_Impl.dart';
import 'package:heyo/app/modules/messaging/connection/data/wifi_direct_messaging_connection.dart';
import 'package:heyo/app/modules/messaging/connection/domain/messaging_connection.dart';
import 'package:heyo/app/modules/messaging/connection/rtc_connection_repo.dart';
import 'package:heyo/app/modules/messaging/multiple_connections.dart';
import 'package:heyo/app/modules/notifications/controllers/notifications_controller.dart';
import 'package:heyo/app/modules/shared/data/repository/db/cache_repository.dart';
import 'package:heyo/app/modules/shared/providers/secure_storage/secure_storage_provider.dart';
import 'package:heyo/app/modules/wifi_direct/controllers/wifi_direct_wrapper.dart';

import '../../chats/data/providers/chat_history/chat_history_provider.dart';
import '../../messaging/connection/connection_repo.dart';
import '../../messaging/connection/wifi_direct_connection_repo.dart';
import '../../messaging/unified_messaging_controller.dart';
import '../../p2p_node/data/key/web3_keys.dart';
import '../../shared/bindings/global_bindings.dart';
import '../../shared/data/models/messages_view_arguments_model.dart';
import '../../shared/data/repository/contact_repository.dart';
import '../../shared/data/repository/crypto_account/account_repository.dart';
import '../../shared/providers/database/app_database.dart';
import '../../shared/providers/database/dao/user_provider.dart';
import '../controllers/messages_controller.dart';
import '../data/message_processor.dart';
import '../data/usecases/delete_message_usecase.dart';
import '../data/usecases/send_message_usecase.dart';
import '../data/usecases/update_message_usecase.dart';

class MessagesBinding extends Bindings {
  @override
  void dependencies() {
    // Determine the connection type
    final args = Get.arguments as MessagesViewArgumentsModel;
    // todo farzam
    final connectionType = args.connectionType == MessagingConnectionType.internet
        ? MessagingConnectionType.internet
        : MessagingConnectionType.wifiDirect;
    final connectionRepository = connectionType == MessagingConnectionType.internet
        ? RTCMessagingConnectionRepository(
            dataHandler: Get.find(),
            dataChannelMessagingConnection: Get.find(),
          )
        : WifiDirectConnectionRepository(
            dataHandler: Get.find(),
            wifiDirectMessagingConnection: Get.find(),
          );

    Get.lazyPut<MessagesController>(
      () => MessagesController(
        readMessageUseCase:
            ReadMessageUseCase(dataHandler: Get.find(), connectionRepository: connectionRepository),
        initMessageUseCase: InitMessageUseCase(connectionRepository: connectionRepository),
        messageRepository: ConnectionMessageRepositoryImpl(
          messagesRepo: MessagesRepo(
            messagesProvider: MessagesProvider(
              appDatabaseProvider: Get.find<AppDatabaseProvider>(),
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
        sendMessageUseCase: SendMessageUseCase(
          messagesRepo: Get.find(),
          connectionRepository: connectionRepository,
          processor: MessageProcessor(),
        ),
        updateMessageUseCase: UpdateMessageUseCase(
          accountInfo: Get.find<AccountRepository>(),
          messagesRepo: MessagesRepo(
            messagesProvider: MessagesProvider(
              appDatabaseProvider: Get.find<AppDatabaseProvider>(),
            ),
          ),
          connectionRepository: connectionRepository,
          processor: MessageProcessor(),
        ),
        deleteMessageUseCase: DeleteMessageUseCase(
          messagesRepo: MessagesRepo(
            messagesProvider:
                MessagesProvider(appDatabaseProvider: Get.find<AppDatabaseProvider>()),
          ),
          connectionRepository: connectionRepository,
          processor: MessageProcessor(),
        ),
      ),
    );
  }
}
