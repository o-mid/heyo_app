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


  MessagingConnectionController({
    required this.multipleConnectionHandler,
    required super.accountInfo,
    required super.messagesRepo,
    required super.chatHistoryRepo,
  });

  //+ remains from previous version
  @override
  void onInit() {
    super.onInit();

    multipleConnectionHandler.onNewRTCSessionCreated = (rtcSession) {
      _observeMessagingStatus(rtcSession);

      rtcSession.dc?.onMessage = (data) async {
        print("onMessageReceived : $data");
        await createUserChatModel(
            sessioncid: rtcSession.remotePeer.remoteCoreId);

        data.isBinary
            ? await handleDataChannelBinary(
                binaryData: data.binary,
                remoteCoreId: rtcSession.remotePeer.remoteCoreId)
            : await handleDataChannelText(
                receivedJson: _decoder.convert(data.text),
                remoteCoreId: rtcSession.remotePeer.remoteCoreId);
      };
    };

  }


  @override
  Future<void> initMessagingConnection({required String remoteId}) async {
    RTCSession rtcSession =
        await multipleConnectionHandler.getConnection(remoteId, null);
    print(
        "initMessagingConnection : ${(!rtcSession.isDataChannelConnectionAvailable)}");
    if (!rtcSession.isDataChannelConnectionAvailable) {
      bool result = await multipleConnectionHandler.initiateSession(rtcSession);
    }
  }

  @override
  Future<void> sendTextMessage(
      {required String text, required String remoteCoreId}) async {
    RTCSession rtcSession =
        await multipleConnectionHandler.getConnection(remoteCoreId, null);
    print(
        "sendTextMessage : ${(!rtcSession.isDataChannelConnectionAvailable)} : ${rtcSession.dc?.state}");

    if (!rtcSession.isDataChannelConnectionAvailable) {
      multipleConnectionHandler.initiateSession(rtcSession);
    }
    await createUserChatModel(sessioncid: rtcSession.remotePeer.remoteCoreId);

    await (rtcSession).dc?.send(RTCDataChannelMessage(text));
  }

  @override
  Future<void> sendBinaryMessage(
      {required Uint8List binary, required String remoteCoreId}) async {
    RTCSession rtcSession =
        await multipleConnectionHandler.getConnection(remoteCoreId, null);
    print(
        "sendTextMessage : ${(!rtcSession.isDataChannelConnectionAvailable)} : ${rtcSession.dc?.state}");
   await createUserChatModel(sessioncid: rtcSession.remotePeer.remoteCoreId);

    if (!rtcSession.isDataChannelConnectionAvailable) {
      multipleConnectionHandler.initiateSession(rtcSession);
    }

    await (await multipleConnectionHandler.getConnection(remoteCoreId, null))
        .dc
        ?.send(RTCDataChannelMessage.fromBinary(binary));
  }

  void _observeMessagingStatus(RTCSession rtcSession) {
    print("onConnectionState for observe ${rtcSession.rtcSessionStatus}");
    rtcSession.onNewRTCSessionStatus = (status) {
      switch (status) {
        case RTCSessionStatus.connected:
          {
            dataChannelStatus.value =
                DataChannelConnectivityStatus.justConnected;

            setConnectivityOnline();
          }
          break;
        case RTCSessionStatus.none:
          {}
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
    };
  }
}
