import 'dart:async';
import 'dart:convert';
import 'package:heyo/app/modules/messages/connection/domain/messaging_connection.dart';
import 'package:heyo/app/modules/messages/connection/domain/messaging_connections_models.dart';

import '../multiple_connections.dart';

class DataChannelMessagingConnection extends MessagingConnection {
  DataChannelMessagingConnection({required this.multipleConnectionHandler}) {
    _init();
  }

  final MultipleConnectionHandler multipleConnectionHandler;
  final JsonDecoder _decoder = const JsonDecoder();
  final StreamController<MessagingConnectionReceivedData> _receivedDataStreamController =
      StreamController<MessagingConnectionReceivedData>.broadcast();

  final StreamController<MessagingConnectionStatus> _connectionStatusStream =
      StreamController<MessagingConnectionStatus>.broadcast();

  void _init() {
    multipleConnectionHandler.onNewRTCSessionCreated = (rtcSession) async {
      rtcSession.onDataChannel = (dataChannel) {
        print('connectionId ${rtcSession.connectionId} ${rtcSession.dc}');
        dataChannel.onMessage = (data) async {
          _receivedDataStreamController.add(
            MessagingConnectionReceivedData(
              remoteCoreId: rtcSession.remotePeer.remoteCoreId,
              receivedJson: _decoder.convert(data.text) as Map<String, dynamic>,
            ),
          );
        };
      };
    };
  }

  @override
  Stream<MessagingConnectionReceivedData> getMessageStream() {
    return _receivedDataStreamController.stream.asBroadcastStream();
  }

  @override
  void init(MessagingConnectionInitialData initialData) {
    multipleConnectionHandler.getConnection(
      initialData.remoteId,
    );
  }

  @override
  Future<void> sendMessage(MessagingConnectionSendData sendData) async {
    final data = sendData as DataChannelConnectionSendData;
    (await multipleConnectionHandler.getConnection(
      data.remoteCoreId,
    ))
        .send(sendData.message);
  }

  @override
  Stream<MessagingConnectionStatus> getConnectionStatus() {
    return _connectionStatusStream.stream.asBroadcastStream();
  }
}
