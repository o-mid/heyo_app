import 'dart:async';
import 'dart:convert';

import 'dart:typed_data';

import 'package:flutter_webrtc/flutter_webrtc.dart';

import 'package:heyo/app/modules/messaging/models.dart';
import 'package:heyo/app/modules/messaging/multiple_connections.dart';

import 'common_messaging_controller.dart';

/// Provides connection establishing and messaging interface for internet connection.
/// This class, like WifiDirectConnectionController, inherits from the CommonMessagingConnectionController.
/// Connection and messaging methods are implemented separately for different connection way,
/// and when messaging initiated, we'll use MessagingConnectionController class instance for regular Internet connection.

class MessagingConnectionController
    extends CommonMessagingConnectionController {
  final MultipleConnectionHandler multipleConnectionHandler;

  final JsonDecoder _decoder = const JsonDecoder();

  //String? selfCoreId;

  //RTCSession? currentRtcSession;
  String currentRemoteId = "";

  MessagingConnectionController({
    required this.multipleConnectionHandler,
    required super.messagesRepo,
    required super.accountInfoRepo,
    required super.chatHistoryRepo,
    required super.notificationsController,
    required super.contactRepository,
  });

  //+ remains from previous version
  @override
  void onInit() {
    super.onInit();

    multipleConnectionHandler.onNewRTCSessionCreated = (rtcSession) {
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
          await createUserChatModel(
              sessioncid: rtcSession.remotePeer.remoteCoreId);

          data.isBinary
              ? await handleDataChannelBinary(
                  binaryData: data.binary,
                  remoteCoreId: rtcSession.remotePeer.remoteCoreId,
                )
              : await handleDataChannelText(
                  receivedJson:
                      _decoder.convert(data.text) as Map<String, dynamic>,
                  remoteCoreId: rtcSession.remotePeer.remoteCoreId,
                );
        };
      };
    };
  }

  @override
  Future<void> initMessagingConnection({required String remoteId}) async {
    RTCSession rtcSession =
        await multipleConnectionHandler.getConnection(remoteId);
    currentRemoteId = rtcSession.remotePeer.remoteCoreId;
    print(
        "initMessagingConnection RTCSession Status: ${rtcSession.rtcSessionStatus}");
    _observeMessagingStatus(rtcSession);
  }

  @override
  Future<void> sendTextMessage(
      {required String text, required String remoteCoreId}) async {
    RTCSession rtcSession =
        await multipleConnectionHandler.getConnection(remoteCoreId);

    await createUserChatModel(sessioncid: remoteCoreId);

    print(
      "sendMessage  : ${rtcSession.connectionId} ${(rtcSession).dc} ${rtcSession.rtcSessionStatus}",
    );
    (rtcSession).dc?.send(RTCDataChannelMessage(text));
  }

  @override
  Future<void> sendBinaryMessage(
      {required Uint8List binary, required String remoteCoreId}) async {
    RTCSession rtcSession =
        await multipleConnectionHandler.getConnection(remoteCoreId);
    print(
      "sendTextMessage : ${(rtcSession.isDataChannelConnectionAvailable)} : ${rtcSession.dc?.state} : ${rtcSession.rtcSessionStatus}",
    );
    await createUserChatModel(sessioncid: remoteCoreId);

    await rtcSession.dc?.send(RTCDataChannelMessage.fromBinary(binary));
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
          dataChannelStatus.value =
              DataChannelConnectivityStatus.connectionLost;
        }
        break;
    }
  }

  void _observeMessagingStatus(RTCSession rtcSession) {
    _applyConnectionStatus(
        rtcSession.rtcSessionStatus, rtcSession.remotePeer.remoteCoreId);

    print(
      "onConnectionState for observe ${rtcSession.rtcSessionStatus} ${rtcSession.connectionId}",
    );
    rtcSession.onNewRTCSessionStatus = (status) {
      _applyConnectionStatus(status, rtcSession.remotePeer.remoteCoreId);
    };
  }
}
