import 'package:get/get.dart';
import 'package:heyo/modules/features/chats/data/local_chat_history_repo.dart';
import 'package:heyo/app/modules/messages/connection/rtc_connection_repo.dart';
import 'package:heyo/app/modules/messages/connection/wifi_direct_connection_repo.dart';
import 'package:heyo/app/modules/messages/controllers/messages_controller.dart';
import 'package:heyo/app/modules/messages/data/message_processor.dart';
import 'package:heyo/app/modules/messages/data/message_repository_impl.dart';
import 'package:heyo/app/modules/messages/data/provider/messages_provider.dart';
import 'package:heyo/app/modules/messages/data/repo/messages_repo.dart';
import 'package:heyo/app/modules/messages/data/usecases/delete_message_usecase.dart';
import 'package:heyo/app/modules/messages/data/usecases/init_message_usecase.dart';
import 'package:heyo/app/modules/messages/data/usecases/read_message_usecase.dart';
import 'package:heyo/app/modules/messages/data/usecases/send_message_usecase.dart';
import 'package:heyo/app/modules/messages/data/usecases/update_message_usecase.dart';
import 'package:heyo/app/modules/messages/data/user_state_repository_Impl.dart';
import 'package:heyo/app/modules/shared/data/models/messages_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/data/providers/database/app_database.dart';
import 'package:heyo/app/modules/shared/data/repository/account/account_repository.dart';
import 'package:heyo/modules/features/contact/usecase/add_contacts_use_case.dart';
import 'package:heyo/modules/features/contact/usecase/get_contact_by_id_use_case.dart';

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
        messageRepository: MessageRepositoryImpl(
          messagesRepo: MessagesRepo(
            messagesProvider: MessagesProvider(
              appDatabaseProvider: Get.find<AppDatabaseProvider>(),
            ),
          ),
        ),
        userStateRepository: UserStateRepositoryImpl(
          addContactUseCase: AddContactUseCase(
            contactRepository: Get.find(),
          ),
          getContactByIdUseCase: GetContactByIdUseCase(
            contactRepository: Get.find(),
          ),
          accountInfo: Get.find<AccountRepository>(),
          messagesRepo: MessagesRepo(
            messagesProvider: MessagesProvider(
              appDatabaseProvider: Get.find(),
            ),
          ),
          chatHistoryRepo: Get.find(),
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
