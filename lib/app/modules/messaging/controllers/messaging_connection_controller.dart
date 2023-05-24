import 'dart:async';
import 'dart:convert';

import 'dart:typed_data';

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';

import 'package:heyo/app/modules/messaging/messaging.dart';
import 'package:heyo/app/modules/messaging/messaging_session.dart';
import 'package:heyo/app/modules/messaging/models.dart';
import 'package:heyo/app/modules/messaging/multiple_connections.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model.dart';
import 'package:heyo/app/routes/app_pages.dart';

import '../../chats/data/models/chat_model.dart';

import '../../shared/data/models/messages_view_arguments_model.dart';

import 'common_messaging_controller.dart';

/// Provides connection establishing and messaging interface for internet connection.
/// This class, like WifiDirectConnectionController, inherits from the CommonMessagingConnectionController.
/// Connection and messaging methods are implemented separately for different connection way,
/// and when messaging initiated, we'll use MessagingConnectionController class instance for regular Internet connection.

class MessagingConnectionController
    extends CommonMessagingConnectionController {
  final MultipleConnectionHandler multipleConnectionHandler;

  final JsonDecoder _decoder = const JsonDecoder();

  MessageSession? currentSession;
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

    // set the value _dataChannel from messaging.dataChannel instance

    // observe the messaging status and set the connectionStatus value and currentSession
    // value base on the changes on messaging.onMessageState
    multipleConnectionHandler.onNewRTCSessionCreated = (rtcSession) {
      rtcSession.dc?.onMessage = (data) async {
        print("debuuuufff ooomad data $data");
        data.isBinary
            ? handleDataChannelBinary(
                binaryData: data.binary,
                remoteCoreId: rtcSession.remotePeer.remoteCoreId)
            : handleDataChannelText(
                receivedJson: _decoder.convert(data.text),
                remoteCoreId: rtcSession.remotePeer.remoteCoreId);
      };
    };
  }

  //+ This method remains from previous version, it's declared in the parent CommonMessagingConnectionController, implemented here.
  @override
  Future<void> initMessagingConnection({required String remoteId}) async {

    RTCSession rtcSession =
        await multipleConnectionHandler.getConnection(remoteId, null);
    if (!rtcSession.isDataChannelConnectionAvailable) {
      bool result=await multipleConnectionHandler.initiateSession(rtcSession);
    }
  }

  //+ This method remains from previous version, it's declared in the parent CommonMessagingConnectionController, implemented here.
  @override
  Future<void> sendTextMessage(
      {required String text, required String remoteCoreId}) async {
    RTCSession rtcSession=await multipleConnectionHandler.getConnection(remoteCoreId, null);
    await (rtcSession)
        .dc
        ?.send(RTCDataChannelMessage(text));
  }

  //+ This method remains from previous version, it's declared in the parent CommonMessagingConnectionController, implemented here.
  @override
  Future<void> sendBinaryMessage(
      {required Uint8List binary, required String remoteCoreId}) async {
    await (await multipleConnectionHandler.getConnection(remoteCoreId, null))
        .dc
        ?.send(RTCDataChannelMessage.fromBinary(binary));
  }

// remains from previous version, but changed to private
  /// Defines callback method for incoming message.
  ///
  /// Since the declaration of callback made in specific instance of corresponding connection way,
  /// this method implemented as private.

// Moved to the parent class CommonMessagingConnectionController
// handleDataChannelBinary()
// handleDataChannelText()
// Future<void> saveReceivedMessage()
// Future<void> deleteReceivedMessage()
// Future<void> updateReceivedMessage()
// Future<void> confirmReceivedMessage()
// createUserChatModel()
// confirmMessageById()
// confirmReadMessages
}
