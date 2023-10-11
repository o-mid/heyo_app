import 'dart:convert';
import 'dart:typed_data';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/chats/data/repos/chat_history/chat_history_abstract_repo.dart';
import 'package:heyo/app/modules/messaging/controllers/common_messaging_controller.dart';
import 'package:heyo/app/modules/messaging/controllers/wifi_direct_connection_controller.dart';
import 'package:heyo/app/modules/messaging/messaging_session.dart';
import 'package:heyo/app/modules/messaging/models.dart';
import 'package:heyo/app/modules/messaging/multiple_connections.dart';
import 'package:heyo/app/modules/messaging/utils/data_binary_message.dart';
import 'package:heyo/app/modules/shared/data/repository/contact_repository.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/mocks/random_avatar_icon.dart';
import 'package:heyo/app/modules/wifi_direct/controllers/wifi_direct_wrapper.dart';
import 'package:heyo_wifi_direct/heyo_wifi_direct.dart';

import '../chats/data/models/chat_model.dart';
import '../messages/data/repo/messages_repo.dart';
import '../new_chat/data/models/user_model.dart';
import '../notifications/controllers/notifications_controller.dart';
import '../p2p_node/data/account/account_info.dart';

import 'dart:convert';
import 'dart:typed_data';

enum ConnectionType { RTC, WiFiDirect }

class UnifiedConnectionController {
  final ConnectionType connectionType;
//   // Shared dependencies
  final AccountInfo accountInfo;
  final MessagesRepo messagesRepo;
  final ChatHistoryLocalAbstractRepo chatHistoryRepo;
  final NotificationsController notificationsController;
  final ContactRepository contactRepository;
  // Fields specific to RTC
  final MultipleConnectionHandler? multipleConnectionHandler;
  String currentRemoteId = "";

  // Fields specific to WiFiDirect
  Rx<WifiDirectConnectivityStatus>? wifiDirectStatus;
  final WifiDirectWrapper? wifiDirectWrapper;
  HeyoWifiDirect? _heyoWifiDirect;
  MessageSession? session;
  String? remoteId;

  UnifiedConnectionController({
    required this.connectionType,
    this.multipleConnectionHandler,
    this.wifiDirectWrapper,
    required this.accountInfo,
    required this.messagesRepo,
    required this.chatHistoryRepo,
    required this.notificationsController,
    required this.contactRepository,
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

  /// Represents current status of used data channel.
  Rx<DataChannelConnectivityStatus> connectivityStatus =
      DataChannelConnectivityStatus.connecting.obs;
  Rx<DataChannelConnectivityStatus> dataChannelStatus =
      DataChannelConnectivityStatus.connecting.obs;

  void _initializeBasedOnConnectionType() {
    if (connectionType == ConnectionType.RTC) {
      _initRTC();
    } else {
      _initWiFiDirect();
    }
  }

  void _initRTC() {
    multipleConnectionHandler?.onNewRTCSessionCreated = (rtcSession) {
      print(
        "onNewRTCSessionCreated : ${rtcSession.connectionId} : ${rtcSession.remotePeer.remoteCoreId} : ${currentRemoteId}",
      );
      if (rtcSession.remotePeer.remoteCoreId == currentRemoteId) {
        _observeMessagingStatus(rtcSession);
      }

      rtcSession.onDataChannel = (dataChannel) {
        print("connectionId ${rtcSession.connectionId} ${rtcSession.dc}");

        dataChannel.onMessage = (data) async {
          print("onMessageReceived : $data ${rtcSession.connectionId}");
          await createUserChatModel(sessioncid: rtcSession.remotePeer.remoteCoreId);

          data.isBinary
              ? await handleDataChannelBinary(
                  binaryData: data.binary,
                  remoteCoreId: rtcSession.remotePeer.remoteCoreId,
                )
              : await handleDataChannelText(
                  receivedJson: _decoder.convert(data.text) as Map<String, dynamic>,
                  remoteCoreId: rtcSession.remotePeer.remoteCoreId,
                );
        };
      };
    };
  }

  void _initWiFiDirect() {
    _heyoWifiDirect = wifiDirectWrapper!.pluginInstance;
    if (_heyoWifiDirect == null) {
      print(
          "HeyoWifiDirect plugin not initialized! Wi-Fi Direct functionality may not be available");
    }
  }

  Future<void> initMessagingConnection({required String remoteId}) async {
    if (connectionType == ConnectionType.RTC) {
      _initRTCConnection(remoteId);
    } else {
      _initWiFiDirectConnection(remoteId);
    }
  }

  Future<void> _initRTCConnection(String remoteId) async {
    RTCSession rtcSession = await multipleConnectionHandler.getConnection(remoteId);
    currentRemoteId = rtcSession.remotePeer.remoteCoreId;
    print("initMessagingConnection RTCSession Status: ${rtcSession.rtcSessionStatus}");
    _observeMessagingStatus(rtcSession);
  }

  void _observeMessagingStatus(RTCSession rtcSession) {
    _applyConnectionStatus(rtcSession.rtcSessionStatus, rtcSession.remotePeer.remoteCoreId);

    print(
      "onConnectionState for observe ${rtcSession.rtcSessionStatus} ${rtcSession.connectionId}",
    );
    rtcSession.onNewRTCSessionStatus = (status) {
      _applyConnectionStatus(status, rtcSession.remotePeer.remoteCoreId);
    };
  }

  void _applyConnectionStatus(RTCSessionStatus status, String remoteCoreId) {
    if (currentRemoteId != remoteCoreId) {
      return;
    }
    switch (status) {
      case RTCSessionStatus.connected:
        {
          dataChannelStatus.value = DataChannelConnectivityStatus.justConnected;
          setConnectivityOnline();
        }
        break;
      case RTCSessionStatus.none:
        {
          dataChannelStatus.value = DataChannelConnectivityStatus.connecting;
        }
        break;
      case RTCSessionStatus.connecting:
        {
          dataChannelStatus.value = DataChannelConnectivityStatus.connecting;
        }
        break;
      case RTCSessionStatus.failed:
        {
          dataChannelStatus.value = DataChannelConnectivityStatus.connectionLost;
        }
        break;
    }
  }

  Future<void> _initWiFiDirectConnection(String remoteId) async {
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
        dataChannelStatus.value = DataChannelConnectivityStatus.justConnected;
        break;
      case PeerStatus.peerConnected:
        dataChannelStatus.value = DataChannelConnectivityStatus.justConnected;
        break;
      default:
        dataChannelStatus.value = DataChannelConnectivityStatus.connectionLost;
        break;
    }
  }

  Future<void> sendTextMessage({required String text, required String remoteCoreId}) async {
    if (connectionType == ConnectionType.RTC) {
      _sendRTCMessage(text, remoteCoreId);
    } else {
      _sendWiFiDirectMessage(text, remoteCoreId);
    }
  }

  Future<void> _sendRTCMessage(String text, String remoteCoreId) async {
    RTCSession rtcSession = await multipleConnectionHandler!.getConnection(remoteCoreId);

    await createUserChatModel(sessioncid: remoteCoreId);

    print(
      "sendMessage  : ${rtcSession.connectionId} ${(rtcSession).dc} ${rtcSession.rtcSessionStatus}",
    );
    (rtcSession).dc?.send(RTCDataChannelMessage(text));
  }

  Future<void> _sendWiFiDirectMessage(String text, String remoteCoreId) async {
// TODO remove debug output
    print('WifiDirectConnectionController(remoteId $remoteId): sendTextMessage($text)');

    // TODO needs to be optimized to remove the redundant null check _heyoWifiDirect
    _initWiFiDirect();

    _heyoWifiDirect!
        .sendMessage(HeyoWifiDirectMessage(receiverId: remoteId!, isBinary: false, body: text));
  }

  // Continued...

  Future<void> sendBinaryMessage({required Uint8List binary, required String remoteCoreId}) async {
    if (connectionType == ConnectionType.RTC) {
      _sendRTCBinary(binary, remoteCoreId);
    } else {
      _sendWiFiDirectBinary(binary, remoteCoreId);
    }
  }

  Future<void> _sendRTCBinary(Uint8List binary, String remoteCoreId) async {
    RTCSession rtcSession = await multipleConnectionHandler!.getConnection(remoteCoreId);
    print(
      "sendTextMessage : ${(rtcSession.isDataChannelConnectionAvailable)} : ${rtcSession.dc?.state} : ${rtcSession.rtcSessionStatus}",
    );
    await createUserChatModel(sessioncid: remoteCoreId);

    await rtcSession.dc?.send(RTCDataChannelMessage.fromBinary(binary));
  }

  Future<void> _sendWiFiDirectBinary(Uint8List binary, String remoteCoreId) async {
    // TODO remove debug output

    DataBinaryMessage sendingMessage = DataBinaryMessage.parse(binary);

    // TODO needs to be optimized to remove the redundant null check _heyoWifiDirect
    _initWiFiDirect();

    // TODO implement binary sending
    print(
      'WifiDirectConnectionController(remoteId $remoteId): sendBinaryData() header ${sendingMessage.header.toString()}',
    );

    _heyoWifiDirect!.sendBinaryData(
      receiver: remoteId!,
      header: sendingMessage.header,
      chunk: sendingMessage.chunk,
    );
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

  // creates a ChatModel and saves it to the chat history if it is not available
  // or updates the available chat
  createUserChatModel({required String sessioncid}) async {
    UserModel? userModel = await contactRepository.getContactById(sessioncid);

    ChatModel userChatModel = ChatModel(
      id: sessioncid,
      isOnline: true,
      name: (userModel == null)
          ? "${sessioncid.characters.take(4).string}...${sessioncid.characters.takeLast(4).string}"
          : userModel.name,
      icon: getMockIconUrl(),
      lastMessage: "",
      lastReadMessageId: "",
      isVerified: true,
      timestamp: DateTime.now(),
    );
    final currentChatModel = await chatHistoryRepo.getChat(userChatModel.id);

    if (currentChatModel == null) {
      await chatHistoryRepo.addChatToHistory(userChatModel);
    } else {
      /*   await chatHistoryRepo.updateChat(userChatModel.copyWith(
        lastMessage: currentChatModel.lastMessage,
        lastReadMessageId: currentChatModel.lastReadMessageId,
        notificationCount: currentChatModel.notificationCount,
        isOnline: true,
      ));*/
    }
  }
}
