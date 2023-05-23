import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/chats/data/repos/chat_history/chat_history_abstract_repo.dart';
import 'package:heyo/app/modules/messages/data/models/messages/confirm_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/delete_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/update_message_model.dart';
import 'package:heyo/app/modules/messaging/usecases/send_data_channel_message_usecase.dart';
import 'package:heyo/app/modules/messaging/messaging.dart';
import 'package:heyo/app/modules/messaging/messaging_session.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model.dart';
import 'package:heyo/app/routes/app_pages.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import '../../chats/data/models/chat_model.dart';
import '../../messages/data/models/messages/image_message_model.dart';
import '../../messages/data/models/messages/message_model.dart';
import '../../messages/data/models/messages/text_message_model.dart';
import '../../messages/data/models/messages/video_message_model.dart';
import '../../messages/data/models/reaction_model.dart';
import '../../messages/data/repo/messages_abstract_repo.dart';
import '../../messages/utils/message_from_json.dart';
import '../../p2p_node/data/account/account_info.dart';
import '../../shared/data/models/messages_view_arguments_model.dart';

import '../../shared/utils/screen-utils/mocks/random_avatar_icon.dart';
import '../models/data_channel_message_model.dart';
import '../usecases/handle_received_binary_data_usecase.dart';
import '../utils/binary_file_receiving_state.dart';
import '../utils/data_binary_message.dart';
import 'common_messaging_controller.dart';

/// Provides connection establishing and messaging interface for internet connection.
/// This class, like WifiDirectConnectionController, inherits from the CommonMessagingConnectionController.
/// Connection and messaging methods are implemented separately for different connection way,
/// and when messaging initiated, we'll use MessagingConnectionController class instance for regular Internet connection.

class MessagingConnectionController extends CommonMessagingConnectionController {
  final Messaging messaging;

  final JsonDecoder _decoder = const JsonDecoder();

  MessageSession? currentSession;
  Rx<ConnectionStatus?> connectionStatus = Rxn<ConnectionStatus>();
  Function(double progress, int totalSize)? statusUpdateCallback;

  late RTCDataChannel _dataChannel;

  MessagingConnectionController({
    required this.messaging,
    required super.accountInfo,
    required super.messagesRepo,
    required super.chatHistoryRepo,
  });

  //+ remains from previous version
  @override
  void onInit() {
    super.onInit();

    // set the value _dataChannel from messaging.dataChannel instance
    _setDataChannel();

    // observe the messaging status and set the connectionStatus value and currentSession
    // value base on the changes on messaging.onMessageState
    _observeMessagingStatus();
  }

  //+ This method remains from previous version, it's declared in the parent CommonMessagingConnectionController, implemented here.
  @override
  Future<void> initMessagingConnection({required String remoteId}) async {
    //checks to see if we have the current session and if we are connected
    bool isConnectionAvailable = connectionStatus.value == ConnectionStatus.CONNECTED ||
        connectionStatus.value == ConnectionStatus.RINGING;

    // if we dont have the current session with the remote id or the connection is not available
    // we start a new connection
    if (currentSession?.cid != remoteId || isConnectionAvailable == false) {
      await _startDataChannelMessaging(remoteId: remoteId);
    } else {
      _channelMessageListener();
    }
  }

  //+ This method remains from previous version, it's declared in the parent CommonMessagingConnectionController, implemented here.
  @override
  Future<void> sendTextMessage({required String text}) async {
    await _dataChannel.send(RTCDataChannelMessage(text));
  }

  //+ This method remains from previous version, it's declared in the parent CommonMessagingConnectionController, implemented here.
  @override
  Future<void> sendBinaryMessage({required Uint8List binary}) async {
    await _dataChannel.send(RTCDataChannelMessage.fromBinary(binary));
  }

  //+ remains from previous version, but changed to private
  void _setDataChannel() {
    messaging.onDataChannel = (_, channel) {
      _dataChannel = channel;
    };
  }

  // remains from previous version, but changed to private
  /// Defines observer callback of connection's status, that status should be
  /// mapping to dataChannelStatus.
  ///
  /// Since connection status depends on specific connection way and callback's
  /// declaration made in corresponding instance, this method implemented as private.
  void _observeMessagingStatus() {
    messaging.onMessageStateChange = (session, status) async {
      print("Message Status changed, state is: $status");

      connectionStatus.value = status;
      currentSession = session;

      switch (status) {
        case ConnectionStatus.RINGING:
          // accept Messaging Connection and navigate to Messaging screen
          await _handleConnectionRinging(session: session);
          break;

        case ConnectionStatus.CONNECTED:
          _channelMessageListener();
          break;

        case ConnectionStatus.BYE:
          // closes the connection and navigate to Chats screen
          handleConnectionClose();
          break;

        case ConnectionStatus.CONNECTING:
          // TODO: Handle this case.
          break;

        case ConnectionStatus.NEW:
          // TODO: Handle this case.
          break;

        case ConnectionStatus.INVITE:
          // TODO: Handle this case.
          break;
      }
      _applyDataChannelConnectivityStatus(status);
    };
  }

  // remains from previous version, but changed to private
  /// Defines callback method for incoming message.
  ///
  /// Since the declaration of callback made in specific instance of corresponding connection way,
  /// this method implemented as private.
  void _channelMessageListener() {
    messaging.onDataChannelMessage = (session, dc, RTCDataChannelMessage data) async {
      data.isBinary
          ? handleDataChannelBinary(binaryData: data.binary, session: session)
          : handleDataChannelText(receivedJson: _decoder.convert(data.text), session: session);
    };
  }

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

  // remains from previous version, but changed to private
  Future<void> _startMessaging({required String remoteId}) async {
    // make the webrtc connection and set the session to current session
    String? selfCoreId = await accountInfo.getCoreId();

    MessageSession session =
        await messaging.connectionRequest(remoteId, 'data', false, selfCoreId!);
    currentSession = session;

    await createUserChatModel(sessioncid: session.cid);
  }

  Future<void> _acceptMessageConnection(MessageSession session) async {
    await messaging.accept(
      session.sid,
    );
  }

  // TODO Don't know how it should be used
  Future<void> messageReceiverSetup({required MessageSession session}) async {
    // await acceptMessageConnection(session);
    _channelMessageListener();
  }

  Future<void> _startDataChannelMessaging({required String remoteId}) async {
    if (remoteId != "") {
      await _startMessaging(
        remoteId: remoteId,
      );
    }
  }

  Future<void> _applyDataChannelConnectivityStatus(ConnectionStatus status) async {
    switch (status) {
      case ConnectionStatus.CONNECTED:
        dataChannelStatus.value = DataChannelConnectivityStatus.justConnected;
        // add a delay to show the just connected status for 2 seconds
        setConnectivityOnline();
        break;

      case ConnectionStatus.BYE:
        dataChannelStatus.value = DataChannelConnectivityStatus.connectionLost;

        break;

      default:
        dataChannelStatus.value = DataChannelConnectivityStatus.connecting;
        break;
    }
  }

  Future<void> _handleConnectionRinging({required MessageSession session}) async {
    await createUserChatModel(sessioncid: session.cid);

    ChatModel? userChatModel;

    await chatHistoryRepo.getChat(session.cid).then((value) {
      userChatModel = value;
    });

    await _acceptMessageConnection(session);

    connectionStatus.value = ConnectionStatus.CONNECTED;

    _applyDataChannelConnectivityStatus(ConnectionStatus.CONNECTED);

    if (userChatModel != null) {
      Get.toNamed(
        Routes.MESSAGES,
        arguments: MessagesViewArgumentsModel(
          session: session,
          user: UserModel(
            iconUrl: userChatModel!.icon,
            name: userChatModel!.name,
            walletAddress: session.cid,
            coreId: session.cid,
            isOnline: true,
          ),
        ),
      );
    }
  }
}
