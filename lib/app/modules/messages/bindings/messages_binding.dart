import 'package:get/get.dart';
import 'package:heyo/app/modules/chats/data/repos/chat_history/chat_history_repo.dart';
import 'package:heyo/app/modules/messages/data/provider/messages_provider.dart';
import 'package:heyo/app/modules/messages/data/repo/messages_repo.dart';
import 'package:heyo/app/modules/messages/data/connection_message_repository_impl.dart';
import 'package:heyo/app/modules/messages/data/user_state_repository_Impl.dart';
import 'package:heyo/app/modules/notifications/controllers/notifications_controller.dart';
import 'package:heyo/app/modules/p2p_node/data/account/account_repo.dart';
import 'package:heyo/app/modules/shared/data/repository/db/cache_repository.dart';
import 'package:heyo/app/modules/shared/providers/secure_storage/secure_storage_provider.dart';

import '../../chats/data/providers/chat_history/chat_history_provider.dart';
import '../../messaging/unified_messaging_controller.dart';
import '../../p2p_node/data/key/web3_keys.dart';
import '../../shared/bindings/global_bindings.dart';
import '../../shared/data/models/messages_view_arguments_model.dart';
import '../../shared/data/repository/contact_repository.dart';
import '../../shared/providers/database/app_database.dart';
import '../../shared/providers/database/dao/user_provider.dart';
import '../controllers/messages_controller.dart';

class MessagesBinding extends Bindings {
  @override
  void dependencies() {
    // Determine the connection type
    final args = Get.arguments as MessagesViewArgumentsModel;
    final connectionType = args.connectionType == MessagingConnectionType.internet
        ? ConnectionType.RTC
        : ConnectionType.WiFiDirect;

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
          messagingController: UnifiedConnectionController(
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
            contactRepository: ContactRepository(
              cacheContractor: CacheRepository(
                  userProvider: UserProvider(appDatabaseProvider: Get.find<AppDatabaseProvider>())),
            ),
            accountInfo: AccountRepo(
              localProvider: SecureStorageProvider(),
              cryptographyKeyGenerator: Web3Keys(
                web3client: GlobalBindings.web3Client,
              ),
            ),
            multipleConnectionHandler: GlobalBindings.multipleConnectionHandler,
            wifiDirectWrapper: GlobalBindings.wifiDirectWrapper,
            notificationsController:
                NotificationsController(appNotifications: GlobalBindings.appNotifications),
            connectionType: connectionType,
          ),
          sendMessageUseCase: Get.find()),
    );
  }
}
