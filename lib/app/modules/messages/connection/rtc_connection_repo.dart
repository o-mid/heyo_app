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
    required List<String> remoteCoreIds,
    required MessageConnectionType messageConnectionType,
    required ChatId chatId,
  }) async {
    final bool isGroupChat = remoteCoreIds.length > 1;

    final chatName = await dataHandler.getChatName(chatId: chatId);
    final selfCoreId = await dataHandler.getSelfCoreId();
    if (!remoteCoreIds.contains(selfCoreId)) {
      remoteCoreIds.add(selfCoreId);
    }

    for (final remoteId in remoteCoreIds) {
      if (remoteId != selfCoreId) {
        await _sendTextMessage(
          text,
          remoteId,
          chatId,
          isGroupChat,
          remoteCoreIds,
          chatName,
        );
      }
    }
  }

  Future<void> _sendTextMessage(
    String text,
    String remoteCoreId,
    ChatId chatId,
    bool isGroupChat,
    List<String> remoteCoreIds,
    String chatName,
  ) async {
    try {
      await dataChannelMessagingConnection.sendMessage(
        DataChannelConnectionSendData(
          remoteCoreId: remoteCoreId,
          message: text,
          chatId: chatId,
          isGroupChat: isGroupChat,
          remoteCoreIds: remoteCoreIds,
          chatName: chatName,
        ),
      );
    } catch (e) {
      print("Failed to send message to $remoteCoreId: $e");
    }
  }

  @override
  Future<void> sendBinaryMessage({
    required Uint8List binary,
    required List<String> remoteCoreIds,
  }) async {
    await dataHandler.createUserChatModel(sessioncid: remoteCoreIds.first);
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
  Future<void> initConnection(
    MessageConnectionType messageConnectionType,
    List<String> remoteCoreIds,
    ChatId chatId,
    String chatName,
  ) async {
    final isGroupChat = remoteCoreIds.length > 1;
    final selfCoreId = await dataHandler.getSelfCoreId();
    if (!remoteCoreIds.contains(selfCoreId)) {
      remoteCoreIds.add(selfCoreId);
    }

    for (final remoteId in remoteCoreIds) {
      if (remoteId != selfCoreId) {
        await _initMessagingConnection(
          remoteId,
          chatId,
          isGroupChat,
          remoteCoreIds,
          chatName,
        );
      }
    }
    ;
  }

  Future<void> _initMessagingConnection(
    String remoteId,
    ChatId chatId,
    bool isGroupChat,
    List<String> remoteCoreIds,
    String chatName,
  ) async {
    try {
      print("Initializing connection with $remoteId");
      dataChannelMessagingConnection.init(
        WebRTCConnectionInitData(
          remoteId: remoteId,
          chatId: chatId,
          isGroupChat: isGroupChat,
          remoteCoreIds: remoteCoreIds,
          chatName: chatName,
        ),
      );
    } catch (e) {
      print("Failed to initialize connection with $remoteId: $e");
    }
  }
}
