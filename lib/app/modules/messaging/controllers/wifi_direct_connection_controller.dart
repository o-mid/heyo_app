import 'dart:async';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:heyo/app/modules/shared/bindings/global_bindings.dart';
import 'package:heyo_wifi_direct/heyo_wifi_direct.dart';

import '../../../routes/app_pages.dart';
import '../../chats/data/models/chat_model.dart';
import '../../new_chat/data/models/user_model.dart';
import '../../shared/data/models/messages_view_arguments_model.dart';
import 'common_messaging_controller.dart';
import 'messaging_connection_controller.dart';

// Todo :  change this status names if needed base on the connection status of the wifi direct
enum WifiDirectConnectivityStatus { connectionLost, connecting, justConnected, online }

class WifiDirectConnectionController extends CommonMessagingConnectionController {

  Rx<WifiDirectConnectivityStatus> wifiDirectStatus = WifiDirectConnectivityStatus.connecting.obs;

  WifiDirectConnectionController({required super.accountInfo, required super.messagesRepo, required super.chatHistoryRepo});

  // TODO since working with HeyoWifiDirectPlugin instance requests usage of streams
  // TODO it is necessary to ensure closing this class instance with closing or
  // TODO canceling streams listeners avoid errors of repeat using.
  HeyoWifiDirect? _heyoWifiDirect;

  String? remoteId;


  @override
  void onInit() {
    super.onInit();

    // TODO remove debug output
    print('WifiDirectConnectionController(remoteId $remoteId): onInit()');
  }


  _initPlugin() {
    _heyoWifiDirect = GlobalBindings.heyoWifiDirect;

  }


  /// Closes current wifi-direct connection when the active messaging closed.
  // TODO implementation
  @override
  void onClose() {
    // TODO remove debug output
    print('WifiDirectConnectionController(remoteId $remoteId): onClose()');
    if (remoteId != null) _heyoWifiDirect?.disconnectPeer(remoteId!);
    super.onClose();
  }

  @override
  Future<void> initMessagingConnection({required String remoteId}) async {
    // TODO remove debug output
    print('WifiDirectConnectionController(remoteId $remoteId): initMessagingConnection($remoteId)');

    this.remoteId = remoteId;
    _initPlugin();

    connectivityStatus.value = ConnectivityStatus.connecting;
    WifiDirectEvent connectionResult =
        await _heyoWifiDirect?.connectPeer(remoteId)
                            ?? WifiDirectEvent(type: EventType.failure, dateTime: DateTime.now());

    if (connectionResult.type == EventType.linkedPeer) {
      connectivityStatus.value = ConnectivityStatus.justConnected;
      setConnectivityOnline();
    } else {
      connectivityStatus.value = ConnectivityStatus.connectionLost;
    }

    print('initMessagingConnection result: ${connectionResult.type.name}');
  }

  @override
  Future<void> sendTextMessage({required String text}) async {
    // TODO remove debug output
    print('WifiDirectConnectionController(remoteId $remoteId): sendTextMessage($text)');
  }

  @override
  Future<void> sendBinaryMessage({required Uint8List binary}) async {
    // TODO remove debug output
    print('WifiDirectConnectionController(remoteId $remoteId): sendBinaryMessage(binary length: ${binary.length})');
  }

  eventHandler(WifiDirectEvent event) {
    print('WifiDirectConnectionController(remoteId $remoteId): WifiDirect event: ${event.type}');
    if (event.type == EventType.linkedPeer) {
      remoteId = (event.message as Peer).coreID;
      _startIncomingMessaging();
    }
  }

  _startIncomingMessaging() async {
    ChatModel? userChatModel;

    setConnectivityOnline();
    await chatHistoryRepo.getChat(remoteId!).then((value) {
      userChatModel = value;
    });

    if (userChatModel != null) {
      Get.toNamed(
        Routes.MESSAGES,
        arguments: MessagesViewArgumentsModel(
          // session: session,
          user: UserModel(
            icon: userChatModel!.icon,
            name: userChatModel!.name,
            walletAddress: remoteId!,
            isOnline: userChatModel!.isOnline,
            chatModel: userChatModel!,
          ),
        ),
      );
    }

  }


  messageHandler(HeyoWifiDirectMessage message) {
    print('WifiDirectConnectionController(remoteId $remoteId): WifiDirect message: ${message.body}, from ${message.senderId}');
  }
}
