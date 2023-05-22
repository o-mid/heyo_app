import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:heyo/app/modules/messaging/utils/data_binary_message.dart';
import 'package:heyo/app/modules/shared/bindings/global_bindings.dart';
import 'package:heyo_wifi_direct/heyo_wifi_direct.dart';

import '../../../routes/app_pages.dart';
import '../../chats/data/models/chat_model.dart';
import '../../new_chat/data/models/user_model.dart';
import '../../shared/data/models/messages_view_arguments_model.dart';
import '../messaging_session.dart';
import 'common_messaging_controller.dart';

// Todo :  change this status names if needed base on the connection status of the wifi direct
enum WifiDirectConnectivityStatus { connectionLost, connecting, justConnected, online }

class WifiDirectConnectionController extends CommonMessagingConnectionController {

  Rx<WifiDirectConnectivityStatus> wifiDirectStatus = WifiDirectConnectivityStatus.connecting.obs;

  WifiDirectConnectionController({required super.accountInfo, required super.messagesRepo, required super.chatHistoryRepo});

  // TODO since working with HeyoWifiDirectPlugin instance requests usage of streams
  // TODO it is necessary to ensure closing this class instance with closing or
  // TODO canceling streams listeners avoid errors of repeat using.
  HeyoWifiDirect? _heyoWifiDirect;

  MessageSession? session;
  String? remoteId;


  @override
  void onInit() {
    super.onInit();

    _initPlugin();
    // TODO remove debug output
    print('WifiDirectConnectionController(remoteId $remoteId): onInit()');
  }


  _initPlugin() {
    _heyoWifiDirect ??= GlobalBindings.heyoWifiDirect;

  }


  /// Closes current wifi-direct connection when the active messaging closed.
  // TODO implementation
  @override
  void onClose() {
    // TODO remove debug output
    print('WifiDirectConnectionController(remoteId $remoteId): onClose()');
    if (remoteId != null) _heyoWifiDirect?.disconnectPeer(remoteId!);
    remoteId = null;
    super.onClose();
  }

  @override
  Future<void> initMessagingConnection({required String remoteId}) async {

    if (this.remoteId == remoteId) {
      // TODO remove debug output
      print('WifiDirectConnectionController(remoteId $remoteId): initMessagingConnection -> already connected');
      return;
    }

    // TODO remove debug output
    print('WifiDirectConnectionController: initMessagingConnection($remoteId)');
    this.remoteId = remoteId;
    _initPlugin();

    dataChannelStatus.value = DataChannelConnectivityStatus.connecting;
    WifiDirectEvent connectionResult =
        await _heyoWifiDirect?.connectPeer(remoteId)
                            ?? WifiDirectEvent(type: EventType.failure, dateTime: DateTime.now());

    if (connectionResult.type == EventType.linkedPeer) {
      dataChannelStatus.value = DataChannelConnectivityStatus.justConnected;
      setConnectivityOnline();
    } else {
      dataChannelStatus.value = DataChannelConnectivityStatus.connectionLost;
    }

    print('initMessagingConnection result: ${connectionResult.type.name}');
  }

  @override
  Future<void> sendTextMessage({required String text}) async {
    // TODO remove debug output
    print('WifiDirectConnectionController(remoteId $remoteId): sendTextMessage($text)');

    // TODO needs to be optimized to remove the redundant null check _heyoWifiDirect
    _initPlugin();

    _heyoWifiDirect!.sendMessage(HeyoWifiDirectMessage(receiverId: remoteId!, isBinary: false, body: text));

  }

  @override
  Future<void> sendBinaryMessage({required Uint8List binary}) async {
    // TODO remove debug output

    DataBinaryMessage sendingMessage = DataBinaryMessage.parse(binary);

    // TODO needs to be optimized to remove the redundant null check _heyoWifiDirect
    _initPlugin();

    // TODO implement binary sending
    print('WifiDirectConnectionController(remoteId $remoteId): sendBinaryData() header ${sendingMessage.header.toString()}');

    _heyoWifiDirect!.sendBinaryData(
        receiver: remoteId!,
        header: sendingMessage.header,
        chunk: sendingMessage.chunk,
    );

  }

  eventHandler(WifiDirectEvent event) {
    print('WifiDirectConnectionController(remoteId $remoteId): WifiDirect event: ${event.type}');
    switch (event.type) {
      case EventType.linkedPeer:
        remoteId = (event.message as Peer).coreID;
        _startIncomingMessaging();
        break;
      case EventType.groupStopped:
        remoteId = null;
        handleConnectionClose();
        break;
      default:
        break;
    }

  }

  _startIncomingMessaging() async {
    ChatModel? userChatModel;

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
          connectionType: MessagingConnectionType.wifiDirect,
        ),
      );
    }
    dataChannelStatus.value = DataChannelConnectivityStatus.justConnected;
    setConnectivityOnline();

  }


  messageHandler(HeyoWifiDirectMessage message) {
    print('WifiDirectConnectionController(remoteId $remoteId): binary: ${message.isBinary}, from ${message.senderId} to ${message.receiverId}');

    MessageSession session = MessageSession(sid: Constants.coreID, cid: remoteId!, pid: remoteId);

    message.isBinary
        ? handleDataChannelBinary(binaryData: message.body, session: session)
        : handleDataChannelText(receivedJson: const JsonDecoder().convert(message.body), session: session);
  }
}
