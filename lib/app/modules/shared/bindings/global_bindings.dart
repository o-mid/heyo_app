import 'package:core_web3dart/credentials.dart';
import 'package:core_web3dart/web3dart.dart';
import 'package:flutter_p2p_communicator/utils/constants.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/account/controllers/account_controller.dart';
import 'package:heyo/app/modules/calls/data/call_status_observer.dart';
import 'package:heyo/app/modules/calls/call_history/controllers/call_history_controller.dart';
import 'package:heyo/app/modules/calls/data/call_requests_processor.dart';
import 'package:heyo/app/modules/calls/data/call_status_provider.dart';
import 'package:heyo/app/modules/calls/data/ios_call_kit/ios_call_kit_provider.dart';
import 'package:heyo/app/modules/calls/data/signaling/call_signaling.dart';
import 'package:heyo/app/modules/calls/data/web_rtc_call_repository.dart';
import 'package:heyo/app/modules/calls/domain/call_repository.dart';
import 'package:heyo/app/modules/calls/shared/data/providers/call_history/call_history_provider.dart';
import 'package:heyo/app/modules/calls/shared/data/repos/call_history/call_history_abstract_repo.dart';
import 'package:heyo/app/modules/calls/shared/data/repos/call_history/call_history_repo.dart';
import 'package:heyo/app/modules/calls/usecase/contact_name_use_case.dart';
import 'package:heyo/app/modules/chats/controllers/chats_controller.dart';
import 'package:heyo/app/modules/connection/data/libp2p_connection_contractor.dart';
import 'package:heyo/app/modules/connection/domain/connection_contractor.dart';
import 'package:heyo/app/modules/messages/connection/connection_data_handler.dart';
import 'package:heyo/app/modules/messages/connection/connection_repo.dart';
import 'package:heyo/app/modules/messages/connection/data/data_channel_messaging_connection.dart';
import 'package:heyo/app/modules/messages/connection/data/received_messaging_data_processor.dart';
import 'package:heyo/app/modules/messages/connection/data/wifi_direct_messaging_connection.dart';
import 'package:heyo/app/modules/messages/connection/rtc_connection_repo.dart';
import 'package:heyo/app/modules/messages/connection/web_rtc_connection_manager.dart';
import 'package:heyo/app/modules/messages/data/usecases/send_message_usecase.dart';
import 'package:heyo/app/modules/notifications/controllers/app_notifications.dart';
import 'package:heyo/app/modules/p2p_node/data/key/web3_keys.dart';
import 'package:heyo/app/modules/p2p_node/p2p_communicator.dart';
import 'package:heyo/app/modules/p2p_node/p2p_node.dart';
import 'package:heyo/app/modules/p2p_node/p2p_node_manager.dart';
import 'package:heyo/app/modules/p2p_node/p2p_node_request.dart';
import 'package:heyo/app/modules/p2p_node/p2p_node_response.dart';
import 'package:heyo/app/modules/p2p_node/p2p_state.dart';
import 'package:heyo/app/modules/shared/controllers/audio_message_controller.dart';
import 'package:heyo/app/modules/shared/controllers/call_history_observer.dart';
import 'package:heyo/app/modules/shared/controllers/connection_controller.dart';
import 'package:heyo/app/modules/shared/controllers/global_message_controller.dart';
import 'package:heyo/app/modules/shared/controllers/live_location_controller.dart';
import 'package:heyo/app/modules/shared/controllers/video_message_controller.dart';
import 'package:heyo/app/modules/shared/data/providers/blockchain/blockchain_provider.dart';
import 'package:heyo/app/modules/shared/data/providers/blockchain/blockchain_provider_impl.dart';
import 'package:heyo/app/modules/shared/data/providers/database/app_database.dart';
import 'package:heyo/app/modules/shared/data/providers/database/dao/user_provider.dart';
import 'package:heyo/app/modules/shared/data/providers/kyc_vault/kyc_vault_provider.dart';
import 'package:heyo/app/modules/shared/data/providers/kyc_vault/kyc_vault_provilder_impl.dart';
import 'package:heyo/app/modules/shared/controllers/app_lifecyle_controller.dart';
import 'package:heyo/app/modules/shared/data/providers/network/dio/dio_network_request.dart';
import 'package:heyo/app/modules/shared/data/providers/network/netowrk_request_provider.dart';
import 'package:heyo/app/modules/shared/data/providers/network/network_credentials.dart';
import 'package:heyo/app/modules/shared/data/providers/notifications/app_notification_provider.dart';
import 'package:heyo/app/modules/shared/data/providers/notifications/notification_provider.dart';
import 'package:heyo/app/modules/shared/data/providers/secure_storage/secure_storage_provider.dart';
import 'package:heyo/app/modules/shared/data/repository/account/account_repository.dart';
import 'package:heyo/app/modules/shared/data/repository/account/app_account_repository.dart';
import 'package:heyo/app/modules/shared/providers/account/creation/account_creation.dart';
import 'package:heyo/app/modules/shared/providers/account/creation/libp2p_account_creation.dart';
import 'package:heyo/app/modules/shared/providers/crypto/storage/libp2p_storage_provider.dart';
import 'package:heyo/app/modules/web-rtc/signaling.dart';
import 'package:heyo/contracts/KYCVault.g.dart';
import 'package:heyo/contracts/Registry.g.dart';
import 'package:heyo/app/modules/calls/data/rtc/multiple_call_connection_handler.dart';
import 'package:heyo/app/modules/calls/data/rtc/single_call_web_rtc_connection.dart';
import 'package:heyo/app/modules/web-rtc/web_rtc_call_connection_manager.dart';
import 'package:http/http.dart' as http;

import '../../chats/data/providers/chat_history/chat_history_provider.dart';
import '../../chats/data/repos/chat_history/chat_history_repo.dart';
import '../../messages/connection/multiple_connections.dart';
import '../../messages/connection/single_webrtc_connection.dart';
import '../../messages/connection/sync_messages.dart';
import '../../messages/data/message_processor.dart';
import '../../messages/data/provider/messages_provider.dart';
import '../../messages/data/repo/messages_abstract_repo.dart';
import '../../messages/data/repo/messages_repo.dart';

import '../../notifications/controllers/notifications_controller.dart';
import '../../wifi_direct/controllers/wifi_direct_wrapper.dart';
import '../controllers/user_preview_controller.dart';
import '../data/repository/contact_repository.dart';
import '../data/repository/db/cache_repository.dart';
import '../utils/constants/web3client_constant.dart';

class GlobalBindings extends Bindings {
  // accountInfo
  static SecureStorageProvider secureStorageProvider = SecureStorageProvider();

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
      ..put(AppLifeCycleController())
      ..put<Registry>(
        Registry(
          address: XCBAddress.fromHex(REGISTRY_ADDR),
          client: web3Client,

          /// Here we should pass network id which is variable that should
          /// be extracted from web3client
          chainId: 3,
        ),
      )
      ..put<AccountRepository>(
        AppAccountRepository(
          libP2PStorageProvider: Get.find(),
          localStorageProvider: secureStorageProvider,
        ),
        permanent: true,
      )
      ..put<NotificationProvider>(
        AppNotificationProvider(
          networkRequest: Get.find(),
          libP2PStorageProvider: Get.find(),
          blockchainProvider: Get.find(),
          accountRepository: Get.find(),
        ),
      )
      ..put<AccountCreation>(LibP2PAccountCreation(
        localProvider: secureStorageProvider,
        cryptographyKeyGenerator: Web3Keys(web3client: web3Client),
        libp2pStorage: Get.find(),
      ))
      ..put(P2PState(), permanent: true)
      ..put(
        P2PCommunicator(
          p2pState: Get.find(),
          libP2PStorageProvider: Get.find(),
        ),
      )
      ..put(
        P2PNodeRequestStream(
          p2pState: Get.find(),
        ),
        permanent: true,
      )
      ..put(
        P2PNodeResponseStream(
          p2pState: Get.find(),
          libP2PStorageProvider: Get.find(),
          accountRepository: Get.find(),
        ),
        permanent: true,
      )
      ..put<P2PNodeController>(
        P2PNodeController(
          p2pNode: P2PNode(
            p2pNodeRequestStream: Get.find(),
            p2pNodeResponseStream: Get.find(),
            p2pState: Get.find(),
            web3client: web3Client,
            libP2PStorageProvider: Get.find(),
            accountCreation: Get.find(),
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
      ..put(AppDatabaseProvider(), permanent: true)
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

      ..put(AppNotifications(), permanent: true)
      ..put(
        NotificationsController(
          appNotifications: Get.find(),
        ),
      )
      ..put(CallSignaling(
          connectionContractor: Get.find(), notificationProvider: Get.find()))
      ..put(CallStatusProvider(callSignaling: Get.find()), permanent: true)
      ..put(
        CallConnectionsHandler(
          callStatusProvider: Get.find(),
          singleCallWebRTCBuilder: SingleCallWebRTCBuilder(
            connectionContractor: Get.find(),
          ),
          callSignaling: Get.find()
        ),
        permanent: true,
      )
      ..put<WebRTCCallRepository>(
        WebRTCCallRepository(
          callConnectionsHandler: Get.find<CallConnectionsHandler>(),
        ),
        permanent: true,
      )
      ..put(
        CallRequestsProcessor(
          connectionContractor: Get.find(),
          callStatusProvider: Get.find(),
          callConnectionsHandler: Get.find(),
        ),
        permanent: true
      )
      ..put(
          CallKitProvider(
              accountInfoRepo: Get.find(),
              contactRepository: ContactRepository(
                cacheContractor: CacheRepository(
                  userProvider: UserProvider(
                      appDatabaseProvider: Get.find<AppDatabaseProvider>(),),
                ),
              ),
              callRepository: Get.find<WebRTCCallRepository>(),),
          permanent: true,)
      ..put(
        CallStatusObserver(
            callStatusProvider: Get.find(),
            accountInfoRepo: Get.find(),
            notificationsController: Get.find(),
            contactRepository: ContactRepository(
              cacheContractor: CacheRepository(
                userProvider: UserProvider(
                    appDatabaseProvider: Get.find<AppDatabaseProvider>()),
              ),
            ),
            appLifeCycleController: Get.find(),
            iOSCallKitProvider: Get.find()),
        permanent: true,
      )

      // call related dependencies
      ..put(
        CallHistoryObserver(
          callHistoryRepo: CallHistoryRepo(
            callHistoryProvider: CallHistoryProvider(
                appDatabaseProvider: Get.find<AppDatabaseProvider>()),
          ),
          callStatusObserver: Get.find(),
          contactRepository: ContactRepository(
            cacheContractor: CacheRepository(
              userProvider: UserProvider(
                  appDatabaseProvider: Get.find<AppDatabaseProvider>()),
            ),
          ),
        ),
      )

      // messaging related dependencies
      ..put(
        DataHandler(
          messagesRepo: MessagesRepo(
            messagesProvider: MessagesProvider(
                appDatabaseProvider: Get.find<AppDatabaseProvider>()),
          ),
          chatHistoryRepo: ChatHistoryLocalRepo(
            chatHistoryProvider: ChatHistoryProvider(
                appDatabaseProvider: Get.find<AppDatabaseProvider>()),
          ),
          notificationsController:
              NotificationsController(appNotifications: appNotifications),
          contactRepository: Get.find(),
          accountInfoRepo: Get.find(),
        ),
        permanent: true,
      )
      ..put<MessagesAbstractRepo>(
        MessagesRepo(
          messagesProvider: MessagesProvider(
              appDatabaseProvider: Get.find<AppDatabaseProvider>()),
        ),
      )
      ..put(WifiDirectWrapper(), permanent: true)
      ..put(
        ChatsController(
          chatHistoryRepo: ChatHistoryLocalRepo(
            chatHistoryProvider: ChatHistoryProvider(
                appDatabaseProvider: Get.find<AppDatabaseProvider>()),
          ),
          messagesRepo: MessagesRepo(
            messagesProvider: MessagesProvider(
                appDatabaseProvider: Get.find<AppDatabaseProvider>()),
          ),
          contactRepository: Get.find<ContactRepository>(),
        ),
      )
      ..put(AccountController(accountInfoRepo: Get.find()))
      ..put(GlobalMessageController())
      ..put(AudioMessageController())
      ..put(VideoMessageController())
      ..put(LiveLocationController())
      ..put(ConnectionController(p2pState: Get.find()))
      ..put(
          DataChannelMessagingConnection(multipleConnectionHandler: Get.find()))
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

      // Get.put<AppNotifications>(
      //   AppNotifications(),
      //   permanent: true,
      // );

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
          callHistoryProvider: CallHistoryProvider(
              appDatabaseProvider: Get.find<AppDatabaseProvider>()),
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
            chatHistoryRepo: ChatHistoryLocalRepo(
              chatHistoryProvider: ChatHistoryProvider(
                appDatabaseProvider: Get.find<AppDatabaseProvider>(),
              ),
            ),
            messagesRepo: MessagesRepo(
              messagesProvider: MessagesProvider(
                  appDatabaseProvider: Get.find<AppDatabaseProvider>()),
            ),
            sendMessageUseCase: SendMessageUseCase(
              messagesRepo: MessagesRepo(
                messagesProvider: MessagesProvider(
                    appDatabaseProvider: Get.find<AppDatabaseProvider>()),
              ),
              connectionRepository:
                  Get.find<RTCMessagingConnectionRepository>(),
              processor: MessageProcessor(),
            ),
          ),
        ),
      )
      ..put(
        CallHistoryController(
          callHistoryRepo: CallHistoryRepo(
            callHistoryProvider: CallHistoryProvider(
              appDatabaseProvider: Get.find<AppDatabaseProvider>(),
            ),
          ),
          contactNameUseCase: ContactNameUseCase(
            contactRepository: ContactRepository(
              cacheContractor: CacheRepository(
                userProvider: UserProvider(
                  appDatabaseProvider: Get.find<AppDatabaseProvider>(),
                ),
              ),
            ),
          ),
        ),
      );
  }
}
