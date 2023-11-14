import 'dart:convert';
import 'dart:typed_data';
import 'package:heyo/app/modules/messaging/connection/connection_data_handler.dart';
import 'package:heyo/app/modules/messaging/connection/connection_repo.dart';
import 'package:heyo/app/modules/messaging/connection/data/data_channel_messaging_connection.dart';
import 'package:heyo/app/modules/messaging/connection/domain/messaging_connections_models.dart';
import 'package:heyo/app/modules/messaging/models.dart';
import '../models/data_channel_message_model.dart';
import '../utils/binary_file_receiving_state.dart';

class RemoteConnectionRepository extends ConnectionRepository {
  RemoteConnectionRepository({
    required this.dataHandler,
    required this.dataChannelMessagingConnection,

  });

  String currentRemoteId = "";
  BinaryFileReceivingState? currentBinaryState;
  final JsonDecoder _decoder = const JsonDecoder();
  final DataHandler dataHandler;
  final DataChannelMessagingConnection dataChannelMessagingConnection;


  @override
  Future<void> sendTextMessage(
      {required String text, required String remoteCoreId, required MessageConnectionType messageConnectionType,
      }) async {
    await dataHandler.createUserChatModel(sessioncid: remoteCoreId);
    if (messageConnectionType == MessageConnectionType.RTC_DATA_CHANNEL) {
      await dataChannelMessagingConnection.sendMessage(
        DataChannelConnectionSendData(
          remoteCoreId: remoteCoreId, message: text,),);
    } else {

    }
  }

  @override
  Future<void> sendBinaryMessage(
      {required Uint8List binary, required String remoteCoreId}) async {
    await dataHandler.createUserChatModel(sessioncid: remoteCoreId);
  }

  Future<void> _observeMessagingStatus(RTCSession rtcSession) async {
    await _applyConnectionStatus(
        rtcSession.rtcSessionStatus, rtcSession.remotePeer.remoteCoreId);

    print(
      "onConnectionState for observe ${rtcSession.rtcSessionStatus} ${rtcSession
          .connectionId}",
    );
    rtcSession.onNewRTCSessionStatus = (status) async {
      await _applyConnectionStatus(status, rtcSession.remotePeer.remoteCoreId);
    };
  }

  Future<void> _applyConnectionStatus(RTCSessionStatus status,
      String remoteCoreId) async {
    if (currentRemoteId != remoteCoreId) {
      return;
    }
    switch (status) {
      case RTCSessionStatus.connected:
        {
          connectivityStatus.value = ConnectivityStatus.justConnected;
          print(ConnectivityStatus.justConnected);
          //await setConnectivityOnline();
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

  @override
  void initConnection(MessageConnectionType messageConnectionType, String remoteId) {
    if (messageConnectionType == MessageConnectionType.RTC_DATA_CHANNEL) {
      dataChannelMessagingConnection.init(
          WebRTCConnectionInitData(remoteId: remoteId));
    } else if (messageConnectionType == MessageConnectionType.WIFI_DIRECT) {

    }
  }
}



/*  /// Handles binary data, received from remote peer.
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


  Future<void> setConnectivityOnline() async {
    await Future.delayed(const Duration(seconds: 2), () {
      connectivityStatus.value = ConnectivityStatus.online;
    });
  }

  @override
  void initConnection(MessageConnectionType messageConnectionType, String remoteId) {
    // TODO: implement initConnection
  }
}

 */
