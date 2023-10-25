import 'dart:convert';
import 'dart:typed_data';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/chats/data/repos/chat_history/chat_history_abstract_repo.dart';
import 'package:heyo/app/modules/messages/data/models/messages/confirm_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/delete_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/image_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/text_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/update_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/reaction_model.dart';
import 'package:heyo/app/modules/messages/utils/message_from_json.dart';
import 'package:heyo/app/modules/messaging/controllers/common_messaging_controller.dart';
import 'package:heyo/app/modules/messaging/controllers/wifi_direct_connection_controller.dart';
import 'package:heyo/app/modules/messaging/messaging_session.dart';
import 'package:heyo/app/modules/messaging/models.dart';
import 'package:heyo/app/modules/messaging/models/data_channel_message_model.dart';
import 'package:heyo/app/modules/messaging/multiple_connections.dart';
import 'package:heyo/app/modules/messaging/usecases/handle_received_binary_data_usecase.dart';
import 'package:heyo/app/modules/messaging/utils/data_binary_message.dart';
import 'package:heyo/app/modules/notifications/data/models/notifications_payload_model.dart';
import 'package:heyo/app/modules/shared/data/repository/contact_repository.dart';
import 'package:heyo/app/modules/shared/utils/constants/notifications_constant.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/mocks/random_avatar_icon.dart';
import 'package:heyo/app/modules/wifi_direct/controllers/wifi_direct_wrapper.dart';
import 'package:heyo/app/routes/app_pages.dart';
import 'package:heyo_wifi_direct/heyo_wifi_direct.dart';

import '../chats/data/models/chat_model.dart';
import '../messages/data/models/messages/message_model.dart';
import '../messages/data/repo/messages_repo.dart';
import '../new_chat/data/models/user_model.dart';
import '../notifications/controllers/notifications_controller.dart';
import '../p2p_node/data/account/account_info.dart';

import 'dart:convert';
import 'dart:typed_data';

import '../shared/data/models/messages_view_arguments_model.dart';
import 'connection/connection_data_handler.dart';
import 'connection/connection_repo.dart';
import 'connection/connection_repo_factory.dart';
import 'connection/rtc_connection_repo_impl.dart';
import 'utils/binary_file_receiving_state.dart';

enum ConnectionType { RTC, WiFiDirect }

// // Todo :  change this status names if needed base on the connection status of the wifi direct
enum WifiDirectConnectivityStatus { connectionLost, connecting, justConnected, online }

enum DataChannelConnectivityStatus { connectionLost, connecting, justConnected, online }

class UnifiedConnectionController {
  final ConnectionType connectionType;
//   // Shared dependencies
  final AccountInfo accountInfo;
  final MessagesRepo messagesRepo;
  final ChatHistoryLocalAbstractRepo chatHistoryRepo;
  final NotificationsController notificationsController;
  final ContactRepository contactRepository;
  // Fields specific to RTC
  final MultipleConnectionHandler? multipleConnectionHandler;
  String currentRemoteId = "";

  // Fields specific to WiFiDirect
  Rx<WifiDirectConnectivityStatus>? wifiDirectStatus;
  final WifiDirectWrapper? wifiDirectWrapper;
  HeyoWifiDirect? _heyoWifiDirect;
  MessageSession? session;
  String? remoteId;
  BinaryFileReceivingState? currentBinaryState;
  ChatModel? userChatmodel;
  final JsonDecoder _decoder = const JsonDecoder();
  late ConnectionRepo connectionRepo;
  late DataHandler dataHandler;

  UnifiedConnectionController({
    required this.connectionType,
    required this.accountInfo,
    required this.messagesRepo,
    required this.chatHistoryRepo,
    required this.notificationsController,
    required this.contactRepository,
    this.multipleConnectionHandler,
    this.wifiDirectWrapper,
    //... other dependencies
  }) {
    if (connectionType == ConnectionType.RTC && multipleConnectionHandler == null) {
      throw ArgumentError("For RTC connection, multipleConnectionHandler is required");
    }
    if (connectionType == ConnectionType.WiFiDirect && wifiDirectWrapper == null) {
      throw ArgumentError("For WiFiDirect connection, wifiDirectWrapper is required");
    }
    _initializeBasedOnConnectionType();
  }

  /// Represents current status of used data channel.
  Rx<DataChannelConnectivityStatus> connectivityStatus =
      DataChannelConnectivityStatus.connecting.obs;
  Rx<DataChannelConnectivityStatus> dataChannelStatus =
      DataChannelConnectivityStatus.connectionLost.obs;

  void _initializeBasedOnConnectionType() {
    final dataHandler = DataHandler(
      messagesRepo: messagesRepo,
      chatHistoryRepo: chatHistoryRepo,
      notificationsController: notificationsController,
      contactRepository: contactRepository,
    );

    connectionRepo = ConnectionRepoFactory.create(connectionType, dataHandler);
    connectionRepo.initConnection(
      multipleConnectionHandler: multipleConnectionHandler,
      wifiDirectWrapper: wifiDirectWrapper,
    );
    // if (connectionType == ConnectionType.RTC) {
    //   // remove if connection
    // } else {
    //   _initWiFiDirect();
    // }
  }

  // void _initWiFiDirect() {
  //   _heyoWifiDirect = wifiDirectWrapper!.pluginInstance;
  //   if (_heyoWifiDirect == null) {
  //     print(
  //       "HeyoWifiDirect plugin not initialized! Wi-Fi Direct functionality may not be available",
  //     );
  //   }
  // }

  Future<void> initMessagingConnection({required String remoteId}) async {
    await connectionRepo.initMessagingConnection(
      remoteId: remoteId,
      multipleConnectionHandler: multipleConnectionHandler,
    );
  }

  Future<void> sendTextMessage({required String text, required String remoteCoreId}) async {
    await connectionRepo.sendTextMessage(text: text, remoteCoreId: remoteCoreId);
  }

  Future<void> sendBinaryMessage({required Uint8List binary, required String remoteCoreId}) async {
    await connectionRepo.sendBinaryMessage(binary: binary, remoteCoreId: remoteCoreId);
  }

  void onClose() {
    if (connectionType == ConnectionType.RTC) {
      // Cleanup for RTC, if any
    } else {
      // Cleanup for WiFi Direct
      if (remoteId != null) _heyoWifiDirect?.disconnectPeer(remoteId!);
      remoteId = null;
    }
  }

  Future<void> setConnectivityOnline() async {
    await Future.delayed(const Duration(seconds: 2), () {
      dataChannelStatus.value = DataChannelConnectivityStatus.online;
      connectivityStatus.value = DataChannelConnectivityStatus.online;
    });
  }

  /// Confirms received message by it's Id, using sendTextMessage() method,
  Future<void> toggleMessageReadConfirm({
    required String messageId,
    required String remoteCoreId,
  }) async {
    final messageJsonEncode = await dataHandler.getMessageJsonEncode(
      messageId: messageId,
      status: ConfirmMessageStatus.read,
      remoteCoreId: remoteCoreId,
    );

    await connectionRepo.sendTextMessage(text: messageJsonEncode, remoteCoreId: remoteCoreId);
  }
}
