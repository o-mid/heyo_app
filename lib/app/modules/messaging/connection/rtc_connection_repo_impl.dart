import 'dart:convert';
import 'dart:typed_data';

import 'package:heyo/app/modules/messaging/connection/connection_repo.dart';
import 'package:heyo/app/modules/messaging/models.dart';
import 'package:heyo/app/modules/messaging/multiple_connections.dart';
import 'package:heyo/app/modules/messaging/unified_messaging_controller.dart';
import 'package:heyo/app/modules/messaging/usecases/handle_received_binary_data_usecase.dart';

import '../models/data_channel_message_model.dart';
import '../utils/binary_file_receiving_state.dart';
import '../utils/data_binary_message.dart';
import 'connection_data_handler.dart';

class RTCConnectionRepoImpl extends ConnectionRepo {
  RTCConnectionRepoImpl({
    required super.dataHandler,
  });

  String currentRemoteId = "";
  BinaryFileReceivingState? currentWebrtcBinaryState;
  final JsonDecoder _decoder = const JsonDecoder();
  // ... fields specific to RTC
  @override
  Future<void> initMessagingConnection({required String remoteId}) async {
    // ... implement RTC logic
  }

  @override
  Future<void> sendTextMessage({required String text, required String remoteCoreId}) async {
    // ... implement RTC logic
  }

  @override
  Future<void> sendBinaryMessage({required Uint8List binary, required String remoteCoreId}) async {
    // ... implement RTC logic
  }

  @override
  Future<void> initConnection({MultipleConnectionHandler? multipleConnectionHandler}) async {
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

  void _observeMessagingStatus(RTCSession rtcSession) {
    //  _applyConnectionStatus(rtcSession.rtcSessionStatus, rtcSession.remotePeer.remoteCoreId);

    print(
      "onConnectionState for observe ${rtcSession.rtcSessionStatus} ${rtcSession.connectionId}",
    );
    rtcSession.onNewRTCSessionStatus = (status) {
      //  _applyConnectionStatus(status, rtcSession.remotePeer.remoteCoreId);
    };
  }

  // Future<void> _applyConnectionStatus(RTCSessionStatus status, String remoteCoreId) async {
  //   if (currentRemoteId != remoteCoreId) {
  //     return;
  //   }
  //   switch (status) {
  //     case RTCSessionStatus.connected:
  //       {
  //         dataChannelStatus.value = DataChannelConnectivityStatus.justConnected;
  //         await setConnectivityOnline();
  //       }
  //     case RTCSessionStatus.none:
  //       {
  //         dataChannelStatus.value = DataChannelConnectivityStatus.connecting;
  //       }
  //     case RTCSessionStatus.connecting:
  //       {
  //         dataChannelStatus.value = DataChannelConnectivityStatus.connecting;
  //       }
  //     case RTCSessionStatus.failed:
  //       {
  //         dataChannelStatus.value = DataChannelConnectivityStatus.connectionLost;
  //       }
  //   }
  // }

  /// Handles binary data, received from remote peer.
  Future<void> handleDataChannelBinary({
    required Uint8List binaryData,
    required String remoteCoreId,
  }) async {
    DataBinaryMessage message = DataBinaryMessage.parse(binaryData);
    print('handleDataChannelBinary header ${message.header.toString()}');
    print('handleDataChannelBinary chunk length ${message.chunk.length}');

    if (message.chunk.isNotEmpty) {
      if (currentWebrtcBinaryState == null) {
        currentWebrtcBinaryState = BinaryFileReceivingState(message.filename, message.meta);
        print('RECEIVER: New file transfer and State started');
      }
      currentWebrtcBinaryState!.pendingMessages[message.chunkStart] = message;
      await dataHandler.handleReceivedBinaryData(
          currentWebrtcBinaryState: currentWebrtcBinaryState!, remoteCoreId: remoteCoreId);
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
        await saveAndConfirmReceivedMessage(
          receivedMessageJson: channelMessage.message,
          chatId: remoteCoreId,
        );

      case DataChannelMessageType.delete:
        await deleteReceivedMessage(
          receivedDeleteJson: channelMessage.message,
          chatId: remoteCoreId,
        );

      case DataChannelMessageType.update:
        await updateReceivedMessage(
          receivedUpdateJson: channelMessage.message,
          chatId: remoteCoreId,
        );

      case DataChannelMessageType.confirm:
        await confirmReceivedMessage(
          receivedconfirmJson: channelMessage.message,
          chatId: remoteCoreId,
        );
    }
  }
}
