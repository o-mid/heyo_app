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
import 'package:heyo_wifi_direct/heyo_wifi_direct.dart';

import '../chats/data/models/chat_model.dart';
import '../messages/data/models/messages/message_model.dart';
import '../messages/data/repo/messages_repo.dart';
import '../new_chat/data/models/user_model.dart';
import '../notifications/controllers/notifications_controller.dart';
import '../p2p_node/data/account/account_info.dart';

import 'dart:convert';
import 'dart:typed_data';

import 'utils/binary_file_receiving_state.dart';

enum ConnectionType { RTC, WiFiDirect }

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
  BinaryFileReceivingState? currentWebrtcBinaryState;
  ChatModel? userChatmodel;
  final JsonDecoder _decoder = const JsonDecoder();

  UnifiedConnectionController({
    required this.connectionType,
    this.multipleConnectionHandler,
    this.wifiDirectWrapper,
    required this.accountInfo,
    required this.messagesRepo,
    required this.chatHistoryRepo,
    required this.notificationsController,
    required this.contactRepository,
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
      DataChannelConnectivityStatus.connecting.obs;

  void _initializeBasedOnConnectionType() {
    if (connectionType == ConnectionType.RTC) {
      _initRTC();
    } else {
      _initWiFiDirect();
    }
  }

  void _initRTC() {
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
          await createUserChatModel(sessioncid: rtcSession.remotePeer.remoteCoreId);

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

  void _initWiFiDirect() {
    _heyoWifiDirect = wifiDirectWrapper!.pluginInstance;
    if (_heyoWifiDirect == null) {
      print(
          "HeyoWifiDirect plugin not initialized! Wi-Fi Direct functionality may not be available");
    }
  }

  Future<void> initMessagingConnection({required String remoteId}) async {
    if (connectionType == ConnectionType.RTC) {
      _initRTCConnection(remoteId);
    } else {
      _initWiFiDirectConnection(remoteId);
    }
  }

  Future<void> _initRTCConnection(String remoteId) async {
    RTCSession rtcSession = await multipleConnectionHandler!.getConnection(remoteId);
    currentRemoteId = rtcSession.remotePeer.remoteCoreId;
    print("initMessagingConnection RTCSession Status: ${rtcSession.rtcSessionStatus}");
    _observeMessagingStatus(rtcSession);
  }

  void _observeMessagingStatus(RTCSession rtcSession) {
    _applyConnectionStatus(rtcSession.rtcSessionStatus, rtcSession.remotePeer.remoteCoreId);

    print(
      "onConnectionState for observe ${rtcSession.rtcSessionStatus} ${rtcSession.connectionId}",
    );
    rtcSession.onNewRTCSessionStatus = (status) {
      _applyConnectionStatus(status, rtcSession.remotePeer.remoteCoreId);
    };
  }

  void _applyConnectionStatus(RTCSessionStatus status, String remoteCoreId) {
    if (currentRemoteId != remoteCoreId) {
      return;
    }
    switch (status) {
      case RTCSessionStatus.connected:
        {
          dataChannelStatus.value = DataChannelConnectivityStatus.justConnected;
          setConnectivityOnline();
        }
        break;
      case RTCSessionStatus.none:
        {
          dataChannelStatus.value = DataChannelConnectivityStatus.connecting;
        }
        break;
      case RTCSessionStatus.connecting:
        {
          dataChannelStatus.value = DataChannelConnectivityStatus.connecting;
        }
        break;
      case RTCSessionStatus.failed:
        {
          dataChannelStatus.value = DataChannelConnectivityStatus.connectionLost;
        }
        break;
    }
  }

  Future<void> _initWiFiDirectConnection(String remoteId) async {
    if (this.remoteId == remoteId) {
      // TODO remove debug output
      print(
        'WifiDirectConnectionController(remoteId $remoteId): initMessagingConnection -> already connected',
      );
      return;
    }

    _initWiFiDirect();

    // TODO remove debug output
    print(
      'WifiDirectConnectionController: initMessagingConnection($remoteId), status ${(_heyoWifiDirect!.peerList.peers[remoteId] as Peer).status.name}',
    );
    this.remoteId = remoteId;

    switch ((_heyoWifiDirect!.peerList.peers[remoteId] as Peer).status) {
      case PeerStatus.peerTCPOpened:
        dataChannelStatus.value = DataChannelConnectivityStatus.justConnected;
        break;
      case PeerStatus.peerConnected:
        dataChannelStatus.value = DataChannelConnectivityStatus.justConnected;
        break;
      default:
        dataChannelStatus.value = DataChannelConnectivityStatus.connectionLost;
        break;
    }
  }

  Future<void> sendTextMessage({required String text, required String remoteCoreId}) async {
    if (connectionType == ConnectionType.RTC) {
      _sendRTCMessage(text, remoteCoreId);
    } else {
      _sendWiFiDirectMessage(text, remoteCoreId);
    }
  }

  Future<void> _sendRTCMessage(String text, String remoteCoreId) async {
    RTCSession rtcSession = await multipleConnectionHandler!.getConnection(remoteCoreId);

    await createUserChatModel(sessioncid: remoteCoreId);

    print(
      "sendMessage  : ${rtcSession.connectionId} ${(rtcSession).dc} ${rtcSession.rtcSessionStatus}",
    );
    (rtcSession).dc?.send(RTCDataChannelMessage(text));
  }

  Future<void> _sendWiFiDirectMessage(String text, String remoteCoreId) async {
// TODO remove debug output
    print('WifiDirectConnectionController(remoteId $remoteId): sendTextMessage($text)');

    // TODO needs to be optimized to remove the redundant null check _heyoWifiDirect
    _initWiFiDirect();

    _heyoWifiDirect!
        .sendMessage(HeyoWifiDirectMessage(receiverId: remoteId!, isBinary: false, body: text));
  }

  // Continued...

  Future<void> sendBinaryMessage({required Uint8List binary, required String remoteCoreId}) async {
    if (connectionType == ConnectionType.RTC) {
      _sendRTCBinary(binary, remoteCoreId);
    } else {
      _sendWiFiDirectBinary(binary, remoteCoreId);
    }
  }

  Future<void> _sendRTCBinary(Uint8List binary, String remoteCoreId) async {
    RTCSession rtcSession = await multipleConnectionHandler!.getConnection(remoteCoreId);
    print(
      "sendTextMessage : ${(rtcSession.isDataChannelConnectionAvailable)} : ${rtcSession.dc?.state} : ${rtcSession.rtcSessionStatus}",
    );
    await createUserChatModel(sessioncid: remoteCoreId);

    await rtcSession.dc?.send(RTCDataChannelMessage.fromBinary(binary));
  }

  Future<void> _sendWiFiDirectBinary(Uint8List binary, String remoteCoreId) async {
    // TODO remove debug output

    DataBinaryMessage sendingMessage = DataBinaryMessage.parse(binary);

    // TODO needs to be optimized to remove the redundant null check _heyoWifiDirect
    _initWiFiDirect();

    // TODO implement binary sending
    print(
      'WifiDirectConnectionController(remoteId $remoteId): sendBinaryData() header ${sendingMessage.header.toString()}',
    );

    _heyoWifiDirect!.sendBinaryData(
      receiver: remoteId!,
      header: sendingMessage.header,
      chunk: sendingMessage.chunk,
    );
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

  // creates a ChatModel and saves it to the chat history if it is not available
  // or updates the available chat
  createUserChatModel({required String sessioncid}) async {
    UserModel? userModel = await contactRepository.getContactById(sessioncid);

    final userChatModel = ChatModel(
      id: sessioncid,
      isOnline: true,
      name: (userModel == null)
          ? "${sessioncid.characters.take(4).string}...${sessioncid.characters.takeLast(4).string}"
          : userModel.name,
      icon: getMockIconUrl(),
      lastMessage: "",
      lastReadMessageId: "",
      isVerified: true,
      timestamp: DateTime.now(),
    );
    final currentChatModel = await chatHistoryRepo.getChat(userChatModel.id);

    if (currentChatModel == null) {
      await chatHistoryRepo.addChatToHistory(userChatModel);
    } else {
      /*   await chatHistoryRepo.updateChat(userChatModel.copyWith(
        lastMessage: currentChatModel.lastMessage,
        lastReadMessageId: currentChatModel.lastReadMessageId,
        notificationCount: currentChatModel.notificationCount,
        isOnline: true,
      ));*/
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
      if (currentWebrtcBinaryState == null) {
        currentWebrtcBinaryState = BinaryFileReceivingState(message.filename, message.meta);
        print('RECEIVER: New file transfer and State started');
      }
      currentWebrtcBinaryState!.pendingMessages[message.chunkStart] = message;
      await HandleReceivedBinaryData(messagesRepo: messagesRepo, chatId: remoteCoreId)
          .execute(state: currentWebrtcBinaryState!, remoteCoreId: remoteCoreId);
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
        break;

      case DataChannelMessageType.delete:
        await deleteReceivedMessage(
          receivedDeleteJson: channelMessage.message,
          chatId: remoteCoreId,
        );
        break;

      case DataChannelMessageType.update:
        await updateReceivedMessage(
          receivedUpdateJson: channelMessage.message,
          chatId: remoteCoreId,
        );
        break;

      case DataChannelMessageType.confirm:
        await confirmReceivedMessage(
          receivedconfirmJson: channelMessage.message,
          chatId: remoteCoreId,
        );
        break;
    }
  }

  Future<void> saveAndConfirmReceivedMessage({
    required Map<String, dynamic> receivedMessageJson,
    required String chatId,
  }) async {
    MessageModel receivedMessage = messageFromJson(receivedMessageJson);
// checks for existing messageId in case of msg duplication
    MessageModel? _currentMsg =
        await messagesRepo.getMessageById(messageId: receivedMessage.messageId, chatId: chatId);
    if (_currentMsg == null) {
      // creates and send delivery confirmtion of msg and push a notification event
      // in case of not existing message
      await messagesRepo.createMessage(
        message: receivedMessage.copyWith(
          isFromMe: false,
          status: receivedMessage.status.deliveredStatus(),
        ),
        chatId: chatId,
      );

      confirmMessageById(
        messageId: receivedMessage.messageId,
        status: ConfirmMessageStatus.delivered,
        remoteCoreId: chatId,
      );

      await updateChatRepoAndNotify(
        receivedMessage: receivedMessage,
        chatId: chatId,
        notify: true,
      );
    } else {
      print('Message already exists');
      // update the existing message and send delivery confirmtion of msg

      await messagesRepo.updateMessage(
        message: receivedMessage.copyWith(
          isFromMe: false,
          status: receivedMessage.status.deliveredStatus(),
        ),
        chatId: chatId,
      );

      confirmMessageById(
        messageId: receivedMessage.messageId,
        status: ConfirmMessageStatus.delivered,
        remoteCoreId: chatId,
      );

      await updateChatRepoAndNotify(
        receivedMessage: receivedMessage,
        chatId: chatId,
        notify: false,
      );
    }
  }

  Future<void> notifyReceivedMessage({
    required MessageModel receivedMessage,
    required String chatId,
    required String senderName,
  }) async {
    await notificationsController.receivedMessageNotify(
      chatId: chatId,
      channelKey: NOTIFICATIONS.messagesChannelKey,

      // largeIcon: 'resource://drawable/usericon',
      title: senderName,
      body: receivedMessage.type == MessageContentType.text
          ? (receivedMessage as TextMessageModel).text
          : receivedMessage.type.name,
      bigPicture: receivedMessage.type == MessageContentType.image
          ? (await messagesRepo.getMessageById(
              messageId: receivedMessage.messageId,
              chatId: chatId,
            ) as ImageMessageModel)
              .url
          : null,
      payload: NotificationsPayloadModel(
        chatId: chatId,
        messageId: receivedMessage.messageId,
        senderName: receivedMessage.senderName,
        replyMsg: receivedMessage.type == MessageContentType.text
            ? (receivedMessage as TextMessageModel).text
            : receivedMessage.type.name,
      ).toJson(),
    );
  }

  Future<void> updateChatRepoAndNotify({
    required MessageModel receivedMessage,
    required String chatId,
    required bool notify,
  }) async {
    userChatmodel ??= await chatHistoryRepo.getChat(chatId);

    int unReadMessagesCount = await messagesRepo.getUnReadMessagesCount(chatId);

    userChatmodel = userChatmodel?.copyWith(
      lastMessage: receivedMessage.type == MessageContentType.text
          ? (receivedMessage as TextMessageModel).text
          : receivedMessage.type.name,
      notificationCount: unReadMessagesCount,
      id: chatId,
      timestamp: receivedMessage.timestamp.toLocal(),
    );

    if (userChatmodel != null) {
      await chatHistoryRepo.updateChat(userChatmodel!);
    }

    if (notify) {
      print("notifyyyyy $chatId");
      UserModel? userModel = await contactRepository.getContactById(chatId);

      await notifyReceivedMessage(
        receivedMessage: receivedMessage,
        chatId: chatId,
        senderName: (userModel == null)
            ? "${chatId.characters.take(4).string}...${chatId.characters.takeLast(4).string}"
            : userModel.name,
      );
    }
  }

  Future<void> deleteReceivedMessage({
    required Map<String, dynamic> receivedDeleteJson,
    required String chatId,
  }) async {
    DeleteMessageModel deleteMessage = DeleteMessageModel.fromJson(receivedDeleteJson);

    await messagesRepo.deleteMessages(messageIds: deleteMessage.messageIds, chatId: chatId);
  }

  Future<void> updateReceivedMessage({
    required Map<String, dynamic> receivedUpdateJson,
    required String chatId,
  }) async {
    final updateMessage = UpdateMessageModel.fromJson(receivedUpdateJson);

    final MessageModel? currentMessage = await messagesRepo.getMessageById(
      messageId: updateMessage.message.messageId,
      chatId: chatId,
    );

    if (currentMessage != null) {
      final receivedReactions = updateMessage.message.reactions.map((key, value) {
        ReactionModel? existingReaction = currentMessage.reactions[key] as ReactionModel?;
        if (existingReaction is ReactionModel) {
          final newValue = value.copyWith(
            isReactedByMe: existingReaction.isReactedByMe,
          );
          return MapEntry(key, newValue);
        }
        return MapEntry(
          key,
          value,
        ); // handle case where the reaction doesn't exist in currentMessage
      });

      await messagesRepo.updateMessage(
        message: currentMessage.copyWith(
          reactions: receivedReactions,
        ),
        chatId: chatId,
      );
    }
  }

  Future<void> confirmReceivedMessage({
    required Map<String, dynamic> receivedconfirmJson,
    required String chatId,
  }) async {
    ConfirmMessageModel confirmMessage = ConfirmMessageModel.fromJson(receivedconfirmJson);

    final String messageId = confirmMessage.messageId;
    if (confirmMessage.status == ConfirmMessageStatus.delivered) {
      MessageModel? currentMessage =
          await messagesRepo.getMessageById(messageId: messageId, chatId: chatId);

      // check if message is found and update the Message status
      if (currentMessage != null) {
        if (currentMessage.status != MessageStatus.read) {
          await messagesRepo.updateMessage(
            message: currentMessage.copyWith(status: MessageStatus.delivered),
            chatId: chatId,
          );
        }
      }
    } else {
      final List<MessageModel> messages = await messagesRepo.getMessages(chatId);
      final index = messages.lastIndexWhere((element) => element.messageId == messageId);
      // print(index);
      // if the message is found create a sublist of messages
      // that the status is not read and are from me

      if (index != -1) {
        final List<MessageModel> messagesToUpdate = messages
            .sublist(0, index + 1)
            .where(
              (element) =>
                  element.isFromMe == true &&
                  (element.status == MessageStatus.delivered ||
                      element.status == MessageStatus.sending),
            )
            .toList();
        // update the status of the messages that need to be update to read
        for (var item in messagesToUpdate) {
          await messagesRepo.updateMessage(
            message: item.copyWith(status: MessageStatus.read),
            chatId: chatId,
          );
        }
      }
    }
  }

  /// Confirms received message by it's Id, using sendTextMessage() method,
  /// defined by the appropriate derived class.
  confirmMessageById({
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
      connectivityStatus.value = DataChannelConnectivityStatus.online;
    });
  }
}
