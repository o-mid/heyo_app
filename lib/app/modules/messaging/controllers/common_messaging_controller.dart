
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../chats/data/models/chat_model.dart';
import '../../chats/data/repos/chat_history/chat_history_abstract_repo.dart';
import '../../messages/data/models/messages/confirm_message_model.dart';
import '../../messages/data/models/messages/delete_message_model.dart';
import '../../messages/data/models/messages/message_model.dart';
import '../../messages/data/models/messages/update_message_model.dart';
import '../../messages/data/models/reaction_model.dart';
import '../../messages/data/repo/messages_abstract_repo.dart';
import '../../messages/utils/message_from_json.dart';
import '../../p2p_node/data/account/account_info.dart';
import '../../shared/utils/screen-utils/mocks/random_avatar_icon.dart';
import '../messaging_session.dart';
import '../models/data_channel_message_model.dart';
import '../usecases/handle_received_binary_data_usecase.dart';
import '../utils/binary_file_receiving_state.dart';
import '../utils/data_binary_message.dart';


enum DataChannelConnectivityStatus { connectionLost, connecting, justConnected, online }

/// Declares common entities for using in specific implementations of Internet or Wi-Fi Direct
/// messaging algorithms.
abstract class CommonMessagingConnectionController extends GetxController {
  final MessagesAbstractRepo messagesRepo;
  final ChatHistoryLocalAbstractRepo chatHistoryRepo;
  final AccountInfo accountInfo;
  BinaryFileReceivingState? currentState;
  //
  // final JsonDecoder _decoder = const JsonDecoder();
  //
  // MessageSession? currentSession;

  /// Represents current status of used data channel.
  // TODO it is necessary to change the source of this property in using classes like DataChannelConnectionStatusWidget
  Rx<DataChannelConnectivityStatus> dataChannelStatus =
      DataChannelConnectivityStatus.connecting.obs;

  //
  CommonMessagingConnectionController(
      { required this.accountInfo,
        required this.messagesRepo,
        required this.chatHistoryRepo
      });

  @override
  void onInit() {
    super.onInit();

    // TODO remove debug
    print('CommonMessagingController initialization');
  }

  // Public abstract methods, that are used for connection control and data transfer
  // are declared below.
  // Since this interactions are different for each connection type,
  // these public methods must be implementation in corresponding derived classes.

  /// Public method, used by MessagesController for initiate messaging connection.
  ///
  /// Should be implemented in the derived class.
  Future<void> initMessagingConnection({required String remoteId});

  /// Sends text message
  ///
  /// Should be overridden in the derived class.
  Future<void> sendTextMessage({required String text});

  /// Sends binary message
  ///
  /// Should be overridden in the derived class.
  Future<void> sendBinaryMessage({required Uint8List binary});


  // Public methods, that are used by derived classes independently of connection type,
  // are declared and implemented below.


  Future<void> setConnectivityOnline() async {
    await Future.delayed(const Duration(seconds: 2), () {
      dataChannelStatus.value = DataChannelConnectivityStatus.online;
    });
  }

  /// Confirms received message by it's Id, using sendTextMessage() method,
  /// defined by the appropriate derived class.
  confirmReceivedMessageById({required String messageId}) {
    Map<String, dynamic> confirmMessageJson = ConfirmMessageModel(messageId: messageId).toJson();

    DataChannelMessageModel dataChannelMessage = DataChannelMessageModel(
      message: confirmMessageJson,
      dataChannelMessagetype: DataChannelMessageType.confirm,
    );

    Map<String, dynamic> dataChannelMessageJson = dataChannelMessage.toJson();

    sendTextMessage(text: jsonEncode(dataChannelMessageJson));
  }

  /// Handles binary data, received from remote peer.
  Future<void> handleDataChannelBinary({
    required Uint8List binaryData,
    required MessageSession session
  }) async {
    DataBinaryMessage message = DataBinaryMessage.parse(binaryData);
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

  /// Handles text data, received from remote peer.
  Future<void> handleDataChannelText({
    required Map<String, dynamic> receivedJson,
    required MessageSession session
  }) async {
    DataChannelMessageModel channelMessage = DataChannelMessageModel.fromJson(receivedJson);

    switch (channelMessage.dataChannelMessagetype) {
      case DataChannelMessageType.message:
        await saveReceivedMessage(
            receivedMessageJson: channelMessage.message,
            chatId: session.cid
        );
        break;

      case DataChannelMessageType.delete:
        await deleteReceivedMessage(
            receivedDeleteJson: channelMessage.message,
            chatId: session.cid
        );
        break;

      case DataChannelMessageType.update:
        await updateReceivedMessage(
            receivedUpdateJson: channelMessage.message,
            chatId: session.cid
        );
        break;

      case DataChannelMessageType.confirm:
        await confirmReceivedMessage(
            receivedConfirmJson: channelMessage.message,
            chatId: session.cid
        );
        break;
    }
  }


  Future<void> saveReceivedMessage(
      {required Map<String, dynamic> receivedMessageJson, required String chatId}) async {
    MessageModel receivedMessage = messageFromJson(receivedMessageJson);

    await messagesRepo.createMessage(
        message: receivedMessage.copyWith(isFromMe: false,),
        chatId: chatId);

    // after saving the message we confirm it and send a text to sender side with the message id
    // to confirm delivery
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
      // get the new reactions and check if user is already reacted to the message or not
      Map<String, ReactionModel> receivedReactions =
      updateMessage.message.reactions.map((key, value) {
        ReactionModel newValue = value.copyWith(
          isReactedByMe: currentMessage.reactions[key]?.isReactedByMe ?? false,
        );
        return MapEntry(key, newValue);
      });

      await messagesRepo.updateMessage(
          message: currentMessage.copyWith(
            reactions: receivedReactions,
          ),
          chatId: chatId);
    }
  }

  Future<void> confirmReceivedMessage(
      {required Map<String, dynamic> receivedConfirmJson, required String chatId}) async {
    ConfirmMessageModel confirmMessage = ConfirmMessageModel.fromJson(receivedConfirmJson);

    final String messageId = confirmMessage.messageId;

    MessageModel? currentMessage =
    await messagesRepo.getMessageById(messageId: messageId, chatId: chatId);
    // check if message is found and update the Message status
    if (currentMessage != null) {
      await messagesRepo.updateMessage(
          message: currentMessage.copyWith(status: MessageStatus.read), chatId: chatId);
    }
  }

  // creates a ChatModel and saves it to the chat history if it is not available
  // or updates the available chat
  Future<void> createUserChatModel({required String sessionCid}) async {
    ChatModel userChatModel = ChatModel(
        id: sessionCid,
        isOnline: true,
        name:
        "${sessionCid.characters.take(4).string}...${sessionCid.characters.takeLast(4).string}",
        icon: getMockIconUrl(),
        lastMessage: "",
        isVerified: true,
        timestamp: DateTime.now());
    final isChatAvailable = await chatHistoryRepo.getChat(userChatModel.id);
    if (isChatAvailable == null) {
      await chatHistoryRepo.addChatToHistory(userChatModel);
    } else {
      await chatHistoryRepo.updateChat(userChatModel);
    }
  }

  handleConnectionClose() {
    if (Get.currentRoute == Routes.MESSAGES) {
      Get.until((route) => Get.currentRoute != Routes.MESSAGES);
    }
  }

}