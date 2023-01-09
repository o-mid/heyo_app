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

enum DataChannelConnectivityStatus { connectionLost, connecting, justConnected, online }

class MessagingConnectionController extends GetxController {
  final Messaging messaging;
  final MessagesAbstractRepo messagesRepo;
  final ChatHistoryLocalAbstractRepo chatHistoryRepo;
  final AccountInfo accountInfo;
  BinaryFileReceivingState? currentState;

  final JsonDecoder _decoder = const JsonDecoder();

  MessageSession? currentSession;
  Rx<ConnectionStatus?> connectionStatus = Rxn<ConnectionStatus>();
  Function(double progress, int totalSize)? statusUpdateCallback;
  Rx<DataChannelConnectivityStatus> dataChannelStatus =
      DataChannelConnectivityStatus.connecting.obs;
  MessagingConnectionController(
      {required this.messaging,
      required this.accountInfo,
      required this.messagesRepo,
      required this.chatHistoryRepo});
  late RTCDataChannel _dataChannel;

  @override
  void onInit() {
    super.onInit();

    setDataChannel();

    observeMessagingStatus();
  }

  void observeMessagingStatus() {
    messaging.onMessageStateChange = (session, status) async {
      connectionStatus.value = status;
      currentSession = session;

      print("Connection Status changed, state is: $status");

      switch (status) {
        case ConnectionStatus.RINGING:
          await handleConnectionRinging(session: session);

          break;

        case ConnectionStatus.CONNECTED:
          print("Connection Status state is: ${status.name}");

          channelMessageListener();
          break;
        case ConnectionStatus.BYE:
          if (Get.currentRoute == Routes.MESSAGES) {
            Get.until((route) => Get.currentRoute != Routes.MESSAGES);
          }
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
      applyConnectivityStatus(status);
    };
  }

  channelMessageListener() {
    messaging.onDataChannelMessage = (session, dc, RTCDataChannelMessage data) async {
      data.isBinary
          ? handleDataChannelBinary(binaryData: data.binary, session: session)
          : handleDataChannelText(receivedjson: _decoder.convert(data.text), session: session);
    };
  }

  handleDataChannelBinary({required Uint8List binaryData, required MessageSession session}) async {
    var message = DataBinaryMessage.parse(binaryData);
    if (message.chunk.isNotEmpty) {
      if (currentState == null) {
        currentState = BinaryFileReceivingState(message.filename, message.meta);
        print('RECEIVER: New file transfer and State started');
      }
      currentState!.pendingMessages[message.chunkStart] = message;
      await HandleReceivedBinaryData(messagesRepo: messagesRepo, chatId: session.cid)
          .execute(state: currentState!);
    } else {
      // handle the acknowledge
      print(message.header);

      return;
    }
  }

  handleDataChannelText(
      {required Map<String, dynamic> receivedjson, required MessageSession session}) async {
    DataChannelMessageModel channelMessage = DataChannelMessageModel.fromJson(receivedjson);

    switch (channelMessage.dataChannelMessagetype) {
      case DataChannelMessageType.message:
        await saveReceivedMessage(receivedMessageJson: channelMessage.message, chatId: session.cid);
        break;

      case DataChannelMessageType.delete:
        await deleteReceivedMessage(
            receivedDeleteJson: channelMessage.message, chatId: session.cid);
        break;

      case DataChannelMessageType.update:
        await updateReceivedMessage(
            receivedUpdateJson: channelMessage.message, chatId: session.cid);

        break;
      case DataChannelMessageType.confirm:
        await confirmReceivedMessage(
            receivedconfirmJson: channelMessage.message, chatId: session.cid);

        break;
    }
  }

  Future<void> saveReceivedMessage(
      {required Map<String, dynamic> receivedMessageJson, required String chatId}) async {
    MessageModel receivedMessage = messageFromJson(receivedMessageJson);
    await messagesRepo.createMessage(
        message: receivedMessage.copyWith(
          isFromMe: false,
        ),
        chatId: chatId);

    confirmReceivedMessageById(messageId: receivedMessage.messageId);
  }

  Future<void> deleteReceivedMessage(
      {required Map<String, dynamic> receivedDeleteJson, required String chatId}) async {
    DeleteMessageModel deleteMessage = DeleteMessageModel.fromJson(receivedDeleteJson);

    await messagesRepo.deleteMessages(messageIds: deleteMessage.messageIds, chatId: chatId);
  }

  Future<void> updateReceivedMessage(
      {required Map<String, dynamic> receivedUpdateJson, required String chatId}) async {
    UpdateMessageModel updateMessage = UpdateMessageModel.fromJson(receivedUpdateJson);
    // this will get the current Message form repo and if message Id is found it will be updated
    MessageModel? currentMessage = await messagesRepo.getMessageById(
        messageId: updateMessage.message.messageId, chatId: chatId);

    if (currentMessage != null) {
      // get the new reactions and check if user is alredy reacted to the message or not
      Map<String, ReactionModel> recivedreactions =
          updateMessage.message.reactions.map((key, value) {
        ReactionModel newValue = value.copyWith(
          isReactedByMe: currentMessage.reactions[key]?.isReactedByMe ?? false,
        );
        return MapEntry(key, newValue);
      });

      await messagesRepo.updateMessage(
          message: currentMessage.copyWith(
            reactions: recivedreactions,
          ),
          chatId: chatId);
    }
  }

  Future<void> confirmReceivedMessage(
      {required Map<String, dynamic> receivedconfirmJson, required String chatId}) async {
    ConfirmMessageModel confirmMessage = ConfirmMessageModel.fromJson(receivedconfirmJson);

    final String messageId = confirmMessage.messageId;

    MessageModel? currentMessage =
        await messagesRepo.getMessageById(messageId: messageId, chatId: chatId);
    // check if message is found and update the Message status
    if (currentMessage != null) {
      await messagesRepo.updateMessage(
          message: currentMessage.copyWith(status: MessageStatus.read), chatId: chatId);
    }
  }

  Future<void> startMessaging({
    required String remoteId,
  }) async {
    // make the webrtc connection and set the session to current session
    String? selfCoreId = await accountInfo.getCoreId();

    MessageSession session =
        await messaging.connectionRequest(remoteId, 'data', false, selfCoreId!);
    currentSession = session;

    await createUserChatModel(sessioncid: session.cid);
  }

  void sendTextMessage({required String text}) async {
    await _dataChannel.send(RTCDataChannelMessage(text));
  }

  void sendBinaryMessage({required Uint8List binary}) async {
    await _dataChannel.send(RTCDataChannelMessage.fromBinary(binary));
  }

  Future acceptMessageConnection(MessageSession session) async {
    await messaging.accept(
      session.sid,
    );
  }

  confirmReceivedMessageById({required String messageId}) async {
    Map<String, dynamic> confirmMessageJson = ConfirmMessageModel(messageId: messageId).toJson();

    DataChannelMessageModel dataChannelMessage = DataChannelMessageModel(
      message: confirmMessageJson,
      dataChannelMessagetype: DataChannelMessageType.confirm,
    );

    Map<String, dynamic> dataChannelMessageJson = dataChannelMessage.toJson();

    sendTextMessage(text: jsonEncode(dataChannelMessageJson));
  }

  void setDataChannel() {
    messaging.onDataChannel = (_, channel) {
      _dataChannel = channel;
    };
  }

  createUserChatModel({required String sessioncid}) async {
    ChatModel userChatModel = ChatModel(
        id: sessioncid,
        isOnline: true,
        name:
            "${sessioncid.characters.take(4).string}...${sessioncid.characters.takeLast(4).string}",
        icon: getMockIconUrl(),
        lastMessage: "",
        isVerified: true,
        timestamp: DateTime.now());
    final isChatAvailable = await chatHistoryRepo.getOneChat(userChatModel.id);
    if (isChatAvailable == null) {
      await chatHistoryRepo.addChatToHistory(userChatModel);
    } else {
      await chatHistoryRepo.updateOneChat(userChatModel);
    }
  }

  initMessagingConnection({required String remoteId}) async {
    //checks to see if we have the current session and if we are connected
    bool isConnectionAvailable = connectionStatus.value == ConnectionStatus.CONNECTED ||
        connectionStatus.value == ConnectionStatus.RINGING;

    if (currentSession?.cid != remoteId || isConnectionAvailable == false) {
      await startDataChannelMessaging(remoteId: remoteId);
    } else {
      channelMessageListener();
    }
  }

  Future<void> messageReceiverSetup({required MessageSession session}) async {
    // await acceptMessageConnection(session);
    channelMessageListener();
  }

  Future<void> startDataChannelMessaging({required String remoteId}) async {
    if (remoteId != "") {
      await startMessaging(
        remoteId: remoteId,
      );
    }
  }

  void applyConnectivityStatus(ConnectionStatus status) async {
    switch (status) {
      case ConnectionStatus.CONNECTED:
        dataChannelStatus.value = DataChannelConnectivityStatus.justConnected;
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

  setConnectivityOnline() async {
    await Future.delayed(const Duration(seconds: 2), () {
      dataChannelStatus.value = DataChannelConnectivityStatus.online;
    });
  }

  handleConnectionRinging({required MessageSession session}) async {
    await createUserChatModel(sessioncid: session.cid);

    ChatModel? userChatModel;

    await chatHistoryRepo.getOneChat(session.cid).then((value) {
      print(value);
      userChatModel = value;
    });

    await acceptMessageConnection(session);

    connectionStatus.value = ConnectionStatus.CONNECTED;

    applyConnectivityStatus(ConnectionStatus.CONNECTED);

    if (userChatModel != null) {
      Get.toNamed(
        Routes.MESSAGES,
        arguments: MessagesViewArgumentsModel(
          session: session,
          user: UserModel(
            icon: userChatModel!.icon,
            name: userChatModel!.name,
            walletAddress: session.cid,
            isOnline: userChatModel!.isOnline,
            chatModel: userChatModel!,
          ),
        ),
      );
    }
  }
}
