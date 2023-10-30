import 'dart:convert';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:heyo/app/modules/messaging/connection/connection_data_handler.dart';
import 'package:heyo/app/modules/messaging/utils/data_binary_message.dart';
import 'package:heyo/app/modules/wifi_direct/controllers/wifi_direct_wrapper.dart';
import 'package:heyo_wifi_direct/heyo_wifi_direct.dart';

import '../../../routes/app_pages.dart';
import '../../chats/data/models/chat_model.dart';
import '../../messages/data/models/messages/confirm_message_model.dart';
import '../../shared/data/models/messages_view_arguments_model.dart';
import '../messaging_session.dart';
import '../models/data_channel_message_model.dart';
import '../multiple_connections.dart';
import '../utils/binary_file_receiving_state.dart';
import 'connection_repo.dart';

class WiFiDirectConnectionRepoImpl extends ConnectionRepo {
  WiFiDirectConnectionRepoImpl({
    required super.dataHandler, // New argument
  });
  WifiDirectWrapper? wifiDirectWrapper;
  HeyoWifiDirect? _heyoWifiDirect;
  BinaryFileReceivingState? currentBinaryState;
  String? remoteId;
  @override
  Future<void> initMessagingConnection(
      {required String remoteId, MultipleConnectionHandler? multipleConnectionHandler}) async {
    if (this.remoteId == remoteId) {
      // TODO remove debug output
      print(
        'WifiDirectConnectionController(remoteId $remoteId): initMessagingConnection -> already connected',
      );
      return;
    }

    _initWiFiDirect();

    // TODO remove debug output
    print(
      'WifiDirectConnectionController: initMessagingConnection($remoteId), status ${(_heyoWifiDirect!.peerList.peers[remoteId] as Peer).status.name}',
    );
    this.remoteId = remoteId;

    switch ((_heyoWifiDirect!.peerList.peers[remoteId] as Peer).status) {
      case PeerStatus.peerTCPOpened:
        connectivityStatus.value = ConnectivityStatus.justConnected;
      case PeerStatus.peerConnected:
        connectivityStatus.value = ConnectivityStatus.justConnected;
      default:
        connectivityStatus.value = ConnectivityStatus.connectionLost;
        break;
    }
  }

  @override
  Future<void> sendTextMessage({required String text, required String remoteCoreId}) async {
// TODO remove debug output
    print('WifiDirectConnectionController(remoteId $remoteCoreId): sendTextMessage($text)');

    // TODO needs to be optimized to remove the redundant null check _heyoWifiDirect
    _initWiFiDirect();

    _heyoWifiDirect!
        .sendMessage(HeyoWifiDirectMessage(receiverId: remoteCoreId!, isBinary: false, body: text));
  }

  @override
  Future<void> sendBinaryMessage({required Uint8List binary, required String remoteCoreId}) async {
    // TODO remove debug output

    DataBinaryMessage sendingMessage = DataBinaryMessage.parse(binary);

    // TODO needs to be optimized to remove the redundant null check _heyoWifiDirect
    _initWiFiDirect();

    // TODO implement binary sending
    print(
      'WifiDirectConnectionController(remoteId $remoteCoreId): sendBinaryData() header ${sendingMessage.header.toString()}',
    );

    _heyoWifiDirect!.sendBinaryData(
      receiver: remoteCoreId,
      header: sendingMessage.header,
      chunk: sendingMessage.chunk,
    );
  }

  @override
  Future<void> initConnection({
    MultipleConnectionHandler? multipleConnectionHandler,
    WifiDirectWrapper? wifiDirectWrapper,
  }) async {
    this.wifiDirectWrapper = wifiDirectWrapper;
  }

  void _initWiFiDirect() {
    _heyoWifiDirect = wifiDirectWrapper!.pluginInstance;
    if (_heyoWifiDirect == null) {
      print(
        "HeyoWifiDirect plugin not initialized! Wi-Fi Direct functionality may not be available",
      );
    }
  }

  void handleWifiDirectEvents(WifiDirectEvent event) {
    print('WifiDirectConnectionController(remoteId $remoteId): WifiDirect event: ${event.type}');
    switch (event.type) {
      case EventType.linkedPeer:
        remoteId = (event.message as Peer).coreID;
        _startIncomingWiFiDirectMessaging();
      case EventType.groupStopped:
        remoteId = null;
        handleWifiDirectConnectionClose();
      default:
        break;
    }
  }

  _startIncomingWiFiDirectMessaging() async {
    ChatModel? userChatModel;

    await dataHandler.chatHistoryRepo.getChat(remoteId!).then((value) {
      userChatModel = value;
    });

    _initWiFiDirect();

    Get.toNamed(
      Routes.MESSAGES,
      arguments: MessagesViewArgumentsModel(
        // session: session,

        coreId: remoteId!,
        iconUrl: userChatModel?.icon,
        connectionType: MessagingConnectionType.wifiDirect,
      ),
    );
    connectivityStatus.value = ConnectivityStatus.justConnected;
    setConnectivityOnline();
  }

  wifiDirectmessageHandler(HeyoWifiDirectMessage message) {
    print(
      'WifiDirectConnectionController(remoteId $remoteId): binary: ${message.isBinary}, from ${message.senderId} to ${message.receiverId}',
    );

    message.isBinary
        ? handleWifiDirectBinary(binaryData: message.body as Uint8List, remoteCoreId: remoteId!)
        : handleWifiDirectText(
            receivedJson:
                const JsonDecoder().convert(message.body as String) as Map<String, dynamic>,
            remoteCoreId: remoteId!,
          );
  }

  handleWifiDirectConnectionClose() {
    if (Get.currentRoute == Routes.MESSAGES) {
      Get.until((route) => Get.currentRoute != Routes.MESSAGES);
    }
  }

  Future<void> setConnectivityOnline() async {
    await Future.delayed(const Duration(seconds: 2), () {
      connectivityStatus.value = ConnectivityStatus.online;
    });
  }

  /// Handles text data, received from remote peer.
  Future<void> handleWifiDirectText({
    required Map<String, dynamic> receivedJson,
    required String remoteCoreId,
  }) async {
    DataChannelMessageModel channelMessage = DataChannelMessageModel.fromJson(receivedJson);
    switch (channelMessage.dataChannelMessagetype) {
      case DataChannelMessageType.message:
        var confirmationValues = await dataHandler.saveReceivedMessage(
          receivedMessageJson: channelMessage.message,
          chatId: remoteCoreId,
        );
        await confirmMessageById(
          messageId: confirmationValues.item1,
          status: confirmationValues.item2,
          remoteCoreId: confirmationValues.item3,
        );
      case DataChannelMessageType.delete:
        await dataHandler.deleteReceivedMessage(
          receivedDeleteJson: channelMessage.message,
          chatId: remoteCoreId,
        );

      case DataChannelMessageType.update:
        await dataHandler.updateReceivedMessage(
          receivedUpdateJson: channelMessage.message,
          chatId: remoteCoreId,
        );

      case DataChannelMessageType.confirm:
        await dataHandler.confirmReceivedMessage(
          receivedconfirmJson: channelMessage.message,
          chatId: remoteCoreId,
        );
    }
  }

  /// Handles binary data, received from remote peer.
  Future<void> handleWifiDirectBinary({
    required Uint8List binaryData,
    required String remoteCoreId,
  }) async {
    DataBinaryMessage message = DataBinaryMessage.parse(binaryData);
    print('handleDataChannelBinary header ${message.header.toString()}');
    print('handleDataChannelBinary chunk length ${message.chunk.length}');

    if (message.chunk.isNotEmpty) {
      if (currentBinaryState == null) {
        currentBinaryState = BinaryFileReceivingState(message.filename, message.meta);
        print('RECEIVER: New file transfer and State started');
      }
      currentBinaryState!.pendingMessages[message.chunkStart] = message;
      await dataHandler.handleReceivedBinaryData(
          currentBinaryState: currentBinaryState!, remoteCoreId: remoteCoreId);
    } else {
      // handle the acknowledge
      print(message.header);

      return;
    }
  }

  Future<void> confirmMessageById({
    required String messageId,
    required ConfirmMessageStatus status,
    required String remoteCoreId,
  }) async {
    Map<String, dynamic> confirmMessageJson =
        ConfirmMessageModel(messageId: messageId, status: status).toJson();

    DataChannelMessageModel dataChannelMessage = DataChannelMessageModel(
      message: confirmMessageJson,
      dataChannelMessagetype: DataChannelMessageType.confirm,
    );

    Map<String, dynamic> dataChannelMessageJson = dataChannelMessage.toJson();

    await sendTextMessage(text: jsonEncode(dataChannelMessageJson), remoteCoreId: remoteCoreId);
  }
}
