import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:heyo/app/modules/messages/data/models/messages/confirm_message_model.dart';
import 'package:heyo/app/modules/messaging/connection/connection_repo.dart';
import 'package:heyo/app/modules/messaging/models.dart';
import 'package:heyo/app/modules/messaging/multiple_connections.dart';
import '../../wifi_direct/controllers/wifi_direct_wrapper.dart';
import '../models/data_channel_message_model.dart';
import '../utils/binary_file_receiving_state.dart';
import '../utils/data_binary_message.dart';

class RTCConnectionRepoImpl extends ConnectionRepo {
  RTCConnectionRepoImpl({
    required super.dataHandler,
  });

  String currentRemoteId = "";
  BinaryFileReceivingState? currentBinaryState;
  final JsonDecoder _decoder = const JsonDecoder();
  late MultipleConnectionHandler multiConnectionHandler;
  @override
  Future<void> initConnection({
    MultipleConnectionHandler? multipleConnectionHandler,
    WifiDirectWrapper? wifiDirectWrapper,
  }) async {
    multiConnectionHandler = multipleConnectionHandler!;
    await listenToRTCSession();
  }

  Future<void> listenToRTCSession() async {
    multiConnectionHandler.onNewRTCSessionCreated = (rtcSession) async {
      print(
        "onNewRTCSessionCreated : ${rtcSession.connectionId} : ${rtcSession.remotePeer.remoteCoreId} : ${currentRemoteId}",
      );
      if (rtcSession.remotePeer.remoteCoreId == currentRemoteId) {
        await _observeMessagingStatus(rtcSession);
      }

      rtcSession.onDataChannel = (dataChannel) {
        print("connectionId ${rtcSession.connectionId} ${rtcSession.dc}");
        _observeMessagingStatus(rtcSession);

        dataChannel.onMessage = (data) async {
          print("onMessageReceived : $data ${rtcSession.connectionId}");
          await dataHandler.createUserChatModel(sessioncid: rtcSession.remotePeer.remoteCoreId);

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

  @override
  Future<void> initMessagingConnection(
      {required String remoteId, MultipleConnectionHandler? multipleConnectionHandler}) async {
    // multiConnectionHandler = multipleConnectionHandler!;
    final rtcSession = await multiConnectionHandler.getConnection(remoteId);
    currentRemoteId = rtcSession.remotePeer.remoteCoreId;
    print("initMessagingConnection RTCSession Status: ${rtcSession.rtcSessionStatus}");

    await _observeMessagingStatus(rtcSession);
  }

  @override
  Future<void> sendTextMessage({required String text, required String remoteCoreId}) async {
    if (multiConnectionHandler == null) {
      throw StateError('multiConnectionHandler has not been initialized');
    }
    RTCSession rtcSession = await multiConnectionHandler!.getConnection(remoteCoreId);

    await dataHandler.createUserChatModel(sessioncid: remoteCoreId);

    print(
      "sendMessage  : ${rtcSession.connectionId} ${(rtcSession).dc} ${rtcSession.rtcSessionStatus}",
    );
    await (rtcSession).dc?.send(RTCDataChannelMessage(text));
    print("text sent");
  }

  @override
  Future<void> sendBinaryMessage({required Uint8List binary, required String remoteCoreId}) async {
    if (multiConnectionHandler == null) {
      throw StateError('multiConnectionHandler has not been initialized');
    }
    RTCSession rtcSession = await multiConnectionHandler.getConnection(remoteCoreId);
    print(
      "sendTextMessage : ${(rtcSession.isDataChannelConnectionAvailable)} : ${rtcSession.dc?.state} : ${rtcSession.rtcSessionStatus}",
    );
    await dataHandler.createUserChatModel(sessioncid: remoteCoreId);

    await rtcSession.dc?.send(RTCDataChannelMessage.fromBinary(binary));
  }

  Future<void> _observeMessagingStatus(RTCSession rtcSession) async {
    await _applyConnectionStatus(rtcSession.rtcSessionStatus, rtcSession.remotePeer.remoteCoreId);

    print(
      "onConnectionState for observe ${rtcSession.rtcSessionStatus} ${rtcSession.connectionId}",
    );
    rtcSession.onNewRTCSessionStatus = (status) async {
      await _applyConnectionStatus(status, rtcSession.remotePeer.remoteCoreId);
    };
  }

  Future<void> _applyConnectionStatus(RTCSessionStatus status, String remoteCoreId) async {
    if (currentRemoteId != remoteCoreId) {
      return;
    }
    switch (status) {
      case RTCSessionStatus.connected:
        {
          connectivityStatus.value = ConnectivityStatus.justConnected;
          print(ConnectivityStatus.justConnected);
          await setConnectivityOnline();
          break;
        }
      case RTCSessionStatus.none:
        {
          connectivityStatus.value = ConnectivityStatus.connecting;
          break;
        }
      case RTCSessionStatus.connecting:
        {
          connectivityStatus.value = ConnectivityStatus.connecting;
          break;
        }
      case RTCSessionStatus.failed:
        {
          connectivityStatus.value = ConnectivityStatus.connectionLost;
          break;
        }
    }
  }

  /// Handles binary data, received from remote peer.
  Future<void> handleDataChannelBinary({
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

  /// Handles text data, received from remote peer.
  Future<void> handleDataChannelText({
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

  Future<void> setConnectivityOnline() async {
    await Future.delayed(const Duration(seconds: 2), () {
      connectivityStatus.value = ConnectivityStatus.online;
    });
  }
}
