import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/chats/data/repos/chat_history/chat_history_abstract_repo.dart';
import 'package:heyo/app/modules/messages/data/models/messages/delete_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/update_message_model.dart';
import 'package:heyo/app/modules/messaging/messaging.dart';
import 'package:heyo/app/modules/messaging/messaging_session.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model.dart';
import 'package:heyo/app/routes/app_pages.dart';

import '../../chats/data/models/chat_model.dart';
import '../../messages/data/models/messages/image_message_model.dart';
import '../../messages/data/models/messages/message_model.dart';
import '../../messages/data/models/reaction_model.dart';
import '../../messages/data/repo/messages_abstract_repo.dart';
import '../../messages/utils/message_from_json.dart';
import '../../p2p_node/data/account/account_info.dart';
import '../../shared/data/models/messages_view_arguments_model.dart';
import '../../shared/utils/screen-utils/mocks/random_avatar_icon.dart';
import '../models/data_channel_message_model.dart';

class MessagingConnectionController extends GetxController {
  final Messaging messaging;
  final MessagesAbstractRepo messagesRepo;
  final ChatHistoryAbstractRepo chatHistoryRepo;
  final AccountInfo accountInfo;
  bool isConnectionConnected = false;
  final JsonDecoder _decoder = const JsonDecoder();
  Rx<ConnectionStatus?> connectionStatus = Rxn<ConnectionStatus>();
  MessagingConnectionController(
      {required this.messaging,
      required this.accountInfo,
      required this.messagesRepo,
      required this.chatHistoryRepo});
  late RTCDataChannel _dataChannel;
  @override
  void onInit() {
    super.onInit();
    messaging.onDataChannel = (_, channel) {
      _dataChannel = channel;
    };
    observeMessagingStatus();
  }

  void observeMessagingStatus() {
    messaging.onMessageStateChange = (session, status) async {
      connectionStatus.value = status;

      print("Connection Status changed, state is: $status");

      if (status == ConnectionStatus.RINGING) {
        ChatModel userChatModel = ChatModel(
            id: session.cid,
            isOnline: true,
            name:
                "${session.cid.characters.take(4).string}...${session.cid.characters.takeLast(4).string}",
            icon: getMockIconUrl(),
            lastMessage: "",
            isVerified: true,
            timestamp: DateTime.now());

        chatHistoryRepo.addChatToHistory(userChatModel);

        Get.toNamed(
          Routes.MESSAGES,
          arguments: MessagesViewArgumentsModel(
            session: session,
            user: UserModel(
              icon: userChatModel.icon,
              name: userChatModel.name,
              walletAddress: session.cid,
              isOnline: userChatModel.isOnline,
              chatModel: userChatModel,
            ),
          ),
        );
      } else if (status == ConnectionStatus.CONNECTED) {
        isConnectionConnected = true;
        print("Connection Status changed, state is: $status");

        channelMessageListener();
      } else if (status == ConnectionStatus.BYE) {
        if (Get.currentRoute == Routes.MESSAGES) {
          Get.until((route) => Get.currentRoute != Routes.MESSAGES);
        }
      }
    };
  }

  channelMessageListener() {
    messaging.onDataChannelMessage = (session, dc, RTCDataChannelMessage data) async {
      if (data.isBinary == false) {
        handleDataChannelMessage(data.text, session);
      }
    };
  }

  handleDataChannelMessage(String receivedText, MessageSession session) async {
    Map<String, dynamic> receivedjson = _decoder.convert(receivedText);
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
        break;
    }
  }

  Future<void> saveReceivedMessage(
      {required Map<String, dynamic> receivedMessageJson, required String chatId}) async {
    MessageModel receivedMessage = messageFromJson(receivedMessageJson);
    print(receivedMessage);

    // Todo omid : add cases for other message types
    if (receivedMessage.type == MessageContentType.image) {
      receivedMessage = (receivedMessage as ImageMessageModel).copyWith(isLocal: false);
    }

    await messagesRepo.createMessage(
        message: receivedMessage.copyWith(
          isFromMe: false,
        ),
        chatId: chatId);
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

  Future<void> startMessaging({
    required String remoteId,
  }) async {
    String? selfCoreId = await accountInfo.getCoreId();

    MessageSession session =
        await messaging.connectionRequest(remoteId, 'data', false, selfCoreId!);
    ChatModel userChatModel = ChatModel(
        id: session.cid,
        name:
            "${session.cid.characters.take(4).string}...${session.cid.characters.takeLast(4).string}",
        icon: getMockIconUrl(),
        lastMessage: "",
        isOnline: true,
        isVerified: true,
        timestamp: DateTime.now());
    chatHistoryRepo.addChatToHistory(userChatModel);
  }

  void sendTextMessage({required String text}) async {
    await _dataChannel.send(RTCDataChannelMessage(text));
  }

  void sendBinaryMessage({required Uint8List binary}) async {
    await _dataChannel.send(RTCDataChannelMessage.fromBinary(binary));
  }

  MessageSession? getSession({required String coreId}) {
    return messaging.getSessions()[coreId];
  }

  Future acceptMessageConnection(MessageSession session) async {
    messaging.accept(
      session.sid,
    );
  }
}
