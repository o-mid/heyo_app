import 'package:get/get.dart';
import 'package:heyo/app/modules/account/controllers/account_controller.dart';
import 'package:heyo/app/modules/call_controller/call_connection_controller.dart';
import 'package:heyo/app/modules/calls/home/controllers/calls_controller.dart';
import 'package:heyo/app/modules/calls/shared/data/providers/call_history/call_history_provider.dart';
import 'package:heyo/app/modules/calls/shared/data/repos/call_history/call_history_abstract_repo.dart';
import 'package:heyo/app/modules/calls/shared/data/repos/call_history/call_history_repo.dart';
import 'package:heyo/app/modules/chats/controllers/chats_controller.dart';
import 'package:heyo/app/modules/connection/domain/connection_contractor.dart';
import 'package:heyo/app/modules/connection/data/libp2p_connection_contractor.dart';
import 'package:heyo/app/modules/messages/data/usecases/send_message_usecase.dart';
import 'package:heyo/app/modules/messaging/single_webrtc_connection.dart';
import 'package:heyo/app/modules/messaging/sync_messages.dart';
import 'package:heyo/app/modules/messaging/web_rtc_connection_manager.dart';
import 'package:heyo/app/modules/notifications/controllers/app_notifications.dart';
import 'package:heyo/app/modules/p2p_node/p2p_communicator.dart';
import 'package:heyo/app/modules/shared/controllers/call_history_observer.dart';
import 'package:heyo/app/modules/shared/controllers/connection_controller.dart';
import 'package:heyo/app/modules/shared/controllers/global_message_controller.dart';
import 'package:heyo/app/modules/shared/controllers/live_location_controller.dart';
import 'package:heyo/app/modules/shared/controllers/audio_message_controller.dart';
import 'package:heyo/app/modules/shared/controllers/video_message_controller.dart';
import 'package:heyo/app/modules/p2p_node/data/account/account_info.dart';
import 'package:heyo/app/modules/p2p_node/data/account/account_repo.dart';
import 'package:heyo/app/modules/p2p_node/data/key/web3_keys.dart';
import 'package:heyo/app/modules/p2p_node/p2p_node.dart';
import 'package:heyo/app/modules/p2p_node/p2p_node_manager.dart';
import 'package:heyo/app/modules/p2p_node/p2p_node_request.dart';
import 'package:heyo/app/modules/p2p_node/p2p_node_response.dart';
import 'package:heyo/app/modules/p2p_node/p2p_state.dart';
import 'package:heyo/app/modules/shared/providers/database/app_database.dart';
import 'package:heyo/app/modules/shared/providers/database/dao/user_provider.dart';
import 'package:heyo/app/modules/shared/providers/secure_storage/secure_storage_provider.dart';
import 'package:core_web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'package:heyo/app/modules/web-rtc/signaling.dart';
import '../../chats/data/providers/chat_history/chat_history_provider.dart';
import '../../chats/data/repos/chat_history/chat_history_repo.dart';
import '../../messages/data/message_processor.dart';
import '../../messages/data/provider/messages_provider.dart';
import '../../messages/data/repo/messages_repo.dart';
import '../../messages/data/usecases/cofirm_message_usecase.dart';
import '../../messages/data/usecases/delete_message_usecase.dart';
import '../../messages/data/usecases/send_message_usecase.dart';
import '../../messages/data/usecases/update_message_usecase.dart';
import '../../messaging/controllers/common_messaging_controller.dart';
import '../../messaging/controllers/messaging_connection_controller.dart';
import '../../messaging/controllers/wifi_direct_connection_controller.dart';
import '../../messaging/unified_messaging_controller.dart';
import '../../notifications/controllers/notifications_controller.dart';
import '../../wifi_direct/controllers/wifi_direct_wrapper.dart';
import '../controllers/user_preview_controller.dart';
import '../data/repository/contact_repository.dart';
import '../data/repository/db/cache_contractor.dart';
import '../data/repository/db/cache_repository.dart';
import '../utils/constants/web3client_constant.dart';
import 'package:heyo/app/modules/messaging/multiple_connections.dart';

class GlobalBindings extends Bindings {
  // accountInfo
  static AccountInfo accountInfo = AccountRepo(
    localProvider: SecureStorageProvider(),
    cryptographyKeyGenerator: Web3Keys(web3client: web3Client),
  );

  // p2p related bindings

  static Web3Client web3Client = Web3Client(
    WEB3CLIENT.url,
    http.Client(),
    WEB3CLIENT.username,
    WEB3CLIENT.password,
  );

// call related bindings

  static AppNotifications appNotifications = AppNotifications();

  @override
  void dependencies() {
    Get
      ..put(P2PState(), permanent: true)
      ..put(P2PCommunicator(p2pState: Get.find(), accountInfo: accountInfo))
      ..put(
        P2PNodeRequestStream(
          p2pState: Get.find(),
        ),
        permanent: true,
      )
      ..put(
        P2PNodeResponseStream(
          p2pState: Get.find(),
        ),
        permanent: true,
      )
      ..put<P2PNodeController>(
        P2PNodeController(
          p2pNode: P2PNode(
            accountInfo: accountInfo,
            p2pNodeRequestStream: Get.find(),
            p2pNodeResponseStream: Get.find(),
            p2pState: Get.find(),
            web3client: web3Client,
          ),
          p2pState: Get.find(),
        ),
        permanent: true,
      )
      ..put<ConnectionContractor>(
        LibP2PConnectionContractor(
          p2pNodeController: Get.find(),
          p2pCommunicator: Get.find(),
        ),
        permanent: true,
      )
      ..put(Signaling(connectionContractor: Get.find()), permanent: true)
      ..put(
        MultipleConnectionHandler(
          connectionContractor: Get.find(),
          singleWebRTCConnection: SingleWebRTCConnection(
            connectionContractor: Get.find(),
            webRTCConnectionManager: WebRTCConnectionManager(),
          ),
        ),
        permanent: true,
      )
      // data base provider dependencies
      ..put(AppDatabaseProvider(accountInfo: accountInfo), permanent: true)
      ..put(
        ContactRepository(
          cacheContractor: CacheRepository(
            userProvider: UserProvider(
              appDatabaseProvider: Get.find<AppDatabaseProvider>(),
            ),
          ),
        ),
      )
      // p2p related dependencies

      ..put(
        CallConnectionController(
          accountInfo: accountInfo,
          signaling: Get.find(),
          notificationsController: NotificationsController(appNotifications: appNotifications),
          contactRepository: ContactRepository(
            cacheContractor: CacheRepository(
              userProvider: UserProvider(appDatabaseProvider: Get.find<AppDatabaseProvider>()),
            ),
          ),
        ),
        permanent: true,
      )

      // call related dependencies
      ..put(
        CallHistoryObserver(
          callHistoryRepo: CallHistoryRepo(
            callHistoryProvider:
                CallHistoryProvider(appDatabaseProvider: Get.find<AppDatabaseProvider>()),
          ),
          callConnectionController: Get.find(),
          contactRepository: ContactRepository(
            cacheContractor: CacheRepository(
              userProvider: UserProvider(appDatabaseProvider: Get.find<AppDatabaseProvider>()),
            ),
          ),
        ),
      )
      ..put(
        CallsController(
          callHistoryRepo: CallHistoryRepo(
            callHistoryProvider: CallHistoryProvider(
              appDatabaseProvider: Get.find<AppDatabaseProvider>(),
            ),
          ),
        ),
      )

      // messaging related dependencies

      ..put(
        ChatsController(
          chatHistoryRepo: ChatHistoryLocalRepo(
            chatHistoryProvider:
                ChatHistoryProvider(appDatabaseProvider: Get.find<AppDatabaseProvider>()),
          ),
          messagesRepo: MessagesRepo(
            messagesProvider:
                MessagesProvider(appDatabaseProvider: Get.find<AppDatabaseProvider>()),
          ),
          contactRepository: Get.find<ContactRepository>(),
        ),
      )
      ..put(AccountController(accountInfo: accountInfo))
      ..put(GlobalMessageController())
      ..put(AudioMessageController())
      ..put(VideoMessageController())
      ..put(LiveLocationController())
      ..put(ConnectionController(p2pState: Get.find()))
      ..put(
        UnifiedConnectionController(
          messagesRepo: MessagesRepo(
            messagesProvider:
                MessagesProvider(appDatabaseProvider: Get.find<AppDatabaseProvider>()),
          ),
          chatHistoryRepo: ChatHistoryLocalRepo(
            chatHistoryProvider:
                ChatHistoryProvider(appDatabaseProvider: Get.find<AppDatabaseProvider>()),
          ),
          contactRepository: ContactRepository(
            cacheContractor: CacheRepository(
              userProvider: UserProvider(appDatabaseProvider: Get.find<AppDatabaseProvider>()),
            ),
          ),
          accountInfo: accountInfo,
          multipleConnectionHandler: MultipleConnectionHandler(
            connectionContractor: Get.find(),
            singleWebRTCConnection: SingleWebRTCConnection(
              connectionContractor: Get.find(),
              webRTCConnectionManager: WebRTCConnectionManager(),
            ),
          ),
          wifiDirectWrapper: WifiDirectWrapper(),
          notificationsController: NotificationsController(appNotifications: appNotifications),
          connectionType: ConnectionType
              .RTC, // You might want to determine this dynamically based on your app logic
        ),
        permanent: true,
      )

      // Get.put<AppNotifications>(
      //   AppNotifications(),
      //   permanent: true,
      // );
      ..put<SendMessageUseCase>(
        SendMessageUseCase(
          messagesRepo: MessagesRepo(
            messagesProvider:
                MessagesProvider(appDatabaseProvider: Get.find<AppDatabaseProvider>()),
          ),
          messagingConnection: Get.find<UnifiedConnectionController>(),
          processor: MessageProcessor(),
        ),
        permanent: true,
      )
      ..put<UpdateMessageUseCase>(
        UpdateMessageUseCase(
          messagesRepo: MessagesRepo(
            messagesProvider:
                MessagesProvider(appDatabaseProvider: Get.find<AppDatabaseProvider>()),
          ),
          messagingConnection: Get.find<UnifiedConnectionController>(),
          processor: MessageProcessor(),
        ),
        permanent: true,
      )
      ..put<DeleteMessageUseCase>(
        DeleteMessageUseCase(
          messagesRepo: MessagesRepo(
            messagesProvider:
                MessagesProvider(appDatabaseProvider: Get.find<AppDatabaseProvider>()),
          ),
          messagingConnection: Get.find<UnifiedConnectionController>(),
          processor: MessageProcessor(),
        ),
        permanent: true,
      )
      ..put<NotificationsController>(
        NotificationsController(
          appNotifications: appNotifications,
        ),
        permanent: true,
      )
      ..put<ChatHistoryLocalRepo>(
        ChatHistoryLocalRepo(
          chatHistoryProvider: ChatHistoryProvider(
            appDatabaseProvider: Get.find(),
          ),
        ),
      )
      ..put<CallHistoryAbstractRepo>(
        CallHistoryRepo(
          callHistoryProvider:
              CallHistoryProvider(appDatabaseProvider: Get.find<AppDatabaseProvider>()),
        ),
      )
      ..put(
        UserPreview(
          contactRepository: Get.find<ContactRepository>(),
          callHistoryRepo: Get.find<CallHistoryAbstractRepo>(),
          chatHistoryRepo: Get.find<ChatHistoryLocalRepo>(),
        ),
      )
      ..put(
        Get.put(
          SyncMessages(
            p2pState: Get.find(),
            multipleConnectionHandler: Get.find(),
            accountInfo: accountInfo,
            chatHistoryRepo: ChatHistoryLocalRepo(
              chatHistoryProvider: ChatHistoryProvider(
                appDatabaseProvider: Get.find<AppDatabaseProvider>(),
              ),
            ),
            messagesRepo: MessagesRepo(
              messagesProvider: MessagesProvider(
                appDatabaseProvider: Get.find(),
              ),
            ),
            sendMessageUseCase: Get.find<SendMessageUseCase>(),
          ),
        ),
      );
  }
}
