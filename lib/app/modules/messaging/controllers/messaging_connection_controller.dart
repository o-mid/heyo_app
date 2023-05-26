import 'dart:async';
import 'dart:convert';

import 'dart:typed_data';

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';

import 'package:heyo/app/modules/messaging/models.dart';
import 'package:heyo/app/modules/messaging/multiple_connections.dart';
import 'package:heyo/app/modules/messaging/usecases/send_data_channel_message_usecase.dart';
import 'package:heyo/app/modules/messaging/messaging.dart';
import 'package:heyo/app/modules/messaging/messaging_session.dart';

import 'common_messaging_controller.dart';

/// Provides connection establishing and messaging interface for internet connection.
/// This class, like WifiDirectConnectionController, inherits from the CommonMessagingConnectionController.
/// Connection and messaging methods are implemented separately for different connection way,
/// and when messaging initiated, we'll use MessagingConnectionController class instance for regular Internet connection.

class MessagingConnectionController
    extends CommonMessagingConnectionController {
  final MultipleConnectionHandler multipleConnectionHandler;

  final JsonDecoder _decoder = const JsonDecoder();

  Rx<ConnectionStatus?> connectionStatus = Rxn<ConnectionStatus>();
  Function(double progress, int totalSize)? statusUpdateCallback;

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
        print("onMessageRe : $data");
        data.isBinary
            ? handleDataChannelBinary(
                binaryData: data.binary,
                remoteCoreId: rtcSession.remotePeer.remoteCoreId)
            : handleDataChannelText(
                receivedJson: _decoder.convert(data.text),
                remoteCoreId: rtcSession.remotePeer.remoteCoreId);
      };
    };
    // observe the messaging status and set the connectionStatus value and currentSession
    // value base on the changes on messaging.onMessageState
  }

  //+ This method remains from previous version, it's declared in the parent CommonMessagingConnectionController, implemented here.

  @override
  Future<void> initMessagingConnection({required String remoteId}) async {
    RTCSession rtcSession =
        await multipleConnectionHandler.getConnection(remoteId, null);
    print("debuuuugggg : ${(!rtcSession.isDataChannelConnectionAvailable)}");
    if (!rtcSession.isDataChannelConnectionAvailable) {
      bool result = await multipleConnectionHandler.initiateSession(rtcSession);
    }
  }

  //+ This method remains from previous version, it's declared in the parent CommonMessagingConnectionController, implemented here.
  @override
  Future<void> sendTextMessage(
      {required String text, required String remoteCoreId}) async {
    RTCSession rtcSession =
        await multipleConnectionHandler.getConnection(remoteCoreId, null);
    print("debuuuugggg send : ${(!rtcSession.isDataChannelConnectionAvailable) } : ${rtcSession.dc?.state}");

    if (!rtcSession.isDataChannelConnectionAvailable) {
       multipleConnectionHandler.initiateSession(rtcSession);

    }
    await (rtcSession).dc?.send(RTCDataChannelMessage(text));
  }

  //+ This method remains from previous version, it's declared in the parent CommonMessagingConnectionController, implemented here.
  @override
  Future<void> sendBinaryMessage(
      {required Uint8List binary, required String remoteCoreId}) async {
    RTCSession rtcSession =
    await multipleConnectionHandler.getConnection(remoteCoreId, null);
    print("debuuuugggg sendB : ${(!rtcSession.isDataChannelConnectionAvailable) } : ${rtcSession.dc?.state}");

    if (!rtcSession.isDataChannelConnectionAvailable) {
      multipleConnectionHandler.initiateSession(rtcSession);
    }

    await (await multipleConnectionHandler.getConnection(remoteCoreId, null))
        .dc
        ?.send(RTCDataChannelMessage.fromBinary(binary));
  }

  // remains from previous version, but changed to private
  /// Defines observer callback of connection's status, that status should be
  /// mapping to dataChannelStatus.
  ///
  /// Since connection status depends on specific connection way and callback's
  /// declaration made in corresponding instance, this method implemented as private.
  void _observeMessagingStatus(RTCSession rtcSession) {

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
            createUserChatModel(sessioncid: rtcSession.remotePeer.remoteCoreId);

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
