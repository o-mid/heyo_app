import 'dart:convert';
import 'dart:typed_data';
import 'package:heyo/app/modules/messages/connection/connection_data_handler.dart';
import 'package:heyo/app/modules/messages/connection/connection_repo.dart';
import 'package:heyo/app/modules/messages/connection/data/data_channel_messaging_connection.dart';
import 'package:heyo/app/modules/messages/connection/domain/messaging_connections_models.dart';
import 'package:heyo/app/modules/messages/connection/models/models.dart';
import '../utils/binary_file_receiving_state.dart';
import 'models/data_channel_message_model.dart';

class RTCMessagingConnectionRepository extends ConnectionRepository {
  RTCMessagingConnectionRepository({
    required this.dataHandler,
    required this.dataChannelMessagingConnection,
  });

  String currentRemoteId = "";
  BinaryFileReceivingState? currentBinaryState;
  final JsonDecoder _decoder = const JsonDecoder();
  final DataHandler dataHandler;
  final DataChannelMessagingConnection dataChannelMessagingConnection;

  @override
  Future<void> sendTextMessage({
    required String text,
    required String remoteCoreId,
    required MessageConnectionType messageConnectionType,
  }) async {
    await dataHandler.createUserChatModel(sessioncid: remoteCoreId);

    await dataChannelMessagingConnection.sendMessage(
      DataChannelConnectionSendData(
        remoteCoreId: remoteCoreId,
        message: text,
      ),
    );
  }

  @override
  Future<void> sendBinaryMessage({required Uint8List binary, required String remoteCoreId}) async {
    await dataHandler.createUserChatModel(sessioncid: remoteCoreId);
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
      dataChannelMessagingConnection.init(WebRTCConnectionInitData(remoteId: remoteId));
    } else if (messageConnectionType == MessageConnectionType.WIFI_DIRECT) {}
  }
}
