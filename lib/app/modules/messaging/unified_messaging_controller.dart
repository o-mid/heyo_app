import 'dart:typed_data';
import 'package:heyo/app/modules/chats/data/repos/chat_history/chat_history_abstract_repo.dart';
import 'package:heyo/app/modules/messages/data/models/messages/confirm_message_model.dart';
import 'package:heyo/app/modules/messages/data/repo/messages_repo.dart';
import 'package:heyo/app/modules/messaging/connection/connection_data_handler.dart';
import 'package:heyo/app/modules/messaging/connection/connection_repo.dart';
import 'package:heyo/app/modules/messaging/connection/connection_repo_factory.dart';
import 'package:heyo/app/modules/messaging/multiple_connections.dart';
import 'package:heyo/app/modules/notifications/controllers/notifications_controller.dart';
import 'package:heyo/app/modules/p2p_node/data/account/account_info.dart';
import 'package:heyo/app/modules/shared/data/repository/contact_repository.dart';
import 'package:heyo/app/modules/wifi_direct/controllers/wifi_direct_wrapper.dart';
import 'package:heyo_wifi_direct/heyo_wifi_direct.dart';

enum ConnectionType { RTC, WiFiDirect }

class UnifiedConnectionController {
  final ConnectionType connectionType;
//   // Shared dependencies
  final AccountInfo accountInfo;
  final MessagesRepo messagesRepo;
  final ChatHistoryLocalAbstractRepo chatHistoryRepo;
  final NotificationsController notificationsController;
  final ContactRepository contactRepository;

  final MultipleConnectionHandler? multipleConnectionHandler;
  String currentRemoteId = "";

  final WifiDirectWrapper? wifiDirectWrapper;
  HeyoWifiDirect? _heyoWifiDirect;

  String? remoteId;

  late ConnectionRepo connectionRepo;
  late DataHandler dataHandler;

  UnifiedConnectionController({
    required this.connectionType,
    required this.accountInfo,
    required this.messagesRepo,
    required this.chatHistoryRepo,
    required this.notificationsController,
    required this.contactRepository,
    this.multipleConnectionHandler,
    this.wifiDirectWrapper,
    //... other dependencies
  }) {
    if (connectionType == ConnectionType.RTC && multipleConnectionHandler == null) {
      throw ArgumentError("For RTC connection, multipleConnectionHandler is required");
    }
    if (connectionType == ConnectionType.WiFiDirect && wifiDirectWrapper == null) {
      throw ArgumentError("For WiFiDirect connection, wifiDirectWrapper is required");
    }
    _initializeBasedOnConnectionType();
  }

  void _initializeBasedOnConnectionType() {
    final dataHandler = DataHandler(
      messagesRepo: messagesRepo,
      chatHistoryRepo: chatHistoryRepo,
      notificationsController: notificationsController,
      contactRepository: contactRepository,
    );

    connectionRepo = ConnectionRepoFactory.create(connectionType, dataHandler);
    connectionRepo.initConnection(
      multipleConnectionHandler: multipleConnectionHandler,
      wifiDirectWrapper: wifiDirectWrapper,
    );
  }

  Future<void> initMessagingConnection({required String remoteId}) async {
    await connectionRepo.initMessagingConnection(
      remoteId: remoteId,
      multipleConnectionHandler: multipleConnectionHandler,
    );
  }

  Future<void> sendTextMessage({required String text, required String remoteCoreId}) async {
    await connectionRepo.sendTextMessage(text: text, remoteCoreId: remoteCoreId);
  }

  Future<void> sendBinaryMessage({required Uint8List binary, required String remoteCoreId}) async {
    await connectionRepo.sendBinaryMessage(binary: binary, remoteCoreId: remoteCoreId);
  }

  void onClose() {
    if (connectionType == ConnectionType.RTC) {
      // Cleanup for RTC, if any
    } else {
      // Cleanup for WiFi Direct
      if (remoteId != null) _heyoWifiDirect?.disconnectPeer(remoteId!);
      remoteId = null;
    }
  }

  Future<void> setConnectivityOnline() async {
    await Future.delayed(const Duration(seconds: 2), () {
      connectionRepo.connectivityStatus.value = ConnectivityStatus.online;
    });
  }

  /// Confirms received message by it's Id, using sendTextMessage() method,
  Future<void> toggleMessageReadConfirm({
    required String messageId,
    required String remoteCoreId,
  }) async {
    final messageJsonEncode = await dataHandler.getMessageJsonEncode(
      messageId: messageId,
      status: ConfirmMessageStatus.read,
      remoteCoreId: remoteCoreId,
    );

    await connectionRepo.sendTextMessage(text: messageJsonEncode, remoteCoreId: remoteCoreId);
  }
}
