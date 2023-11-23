import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model/user_model.dart';
import 'package:heyo/app/modules/shared/data/repository/crypto_account/account_repository.dart';
import 'package:heyo/app/modules/shared/data/repository/contact_repository.dart';

import '../../../routes/app_pages.dart';
import '../../chats/data/models/chat_model.dart';
import '../../chats/data/repos/chat_history/chat_history_abstract_repo.dart';
import '../../messages/data/models/messages/confirm_message_model.dart';
import '../../messages/data/models/messages/delete_message_model.dart';
import '../../messages/data/models/messages/image_message_model.dart';
import '../../messages/data/models/messages/message_model.dart';
import '../../messages/data/models/messages/text_message_model.dart';
import '../../messages/data/models/messages/update_message_model.dart';
import '../../messages/data/models/reaction_model.dart';
import '../../messages/data/repo/messages_abstract_repo.dart';
import '../../messages/utils/message_from_json.dart';

import '../../notifications/controllers/notifications_controller.dart';
import '../../notifications/data/models/notifications_payload_model.dart';
import '../../shared/utils/constants/notifications_constant.dart';
import '../../shared/utils/screen-utils/mocks/random_avatar_icon.dart';
import '../models/data_channel_message_model.dart';
import '../usecases/handle_received_binary_data_usecase.dart';
import '../utils/binary_file_receiving_state.dart';
import '../utils/data_binary_message.dart';

enum DataChannelConnectivityStatus {
  connectionLost,
  connecting,
  justConnected,
  online
}

/// Declares common entities for using in specific implementations of Internet or Wi-Fi Direct
/// messaging algorithms.
///
/// There are two classes inherited from it, MessagingConnectionController and WifiDirectConnectionController.
/// An instance of one or another class-heir will be used in messaging depending on the connection method, Internet or Wi-Fi Direct.
abstract class CommonMessagingConnectionController extends GetxController {
  final MessagesAbstractRepo messagesRepo;
  final ChatHistoryLocalAbstractRepo chatHistoryRepo;
  final AccountRepository accountInfoRepo;
  BinaryFileReceivingState? currentState;
  final NotificationsController notificationsController;
  final ContactRepository contactRepository;

  //
  // final JsonDecoder _decoder = const JsonDecoder();
  //
  // MessageSession? currentSession;

  /// Represents current status of used data channel.
  Rx<DataChannelConnectivityStatus> connectivityStatus =
      DataChannelConnectivityStatus.connecting.obs;
  Rx<DataChannelConnectivityStatus> dataChannelStatus =
      DataChannelConnectivityStatus.connecting.obs;

  //

  ChatModel? userChatmodel;

  CommonMessagingConnectionController({
    required this.accountInfoRepo,
    required this.messagesRepo,
    required this.chatHistoryRepo,
    required this.notificationsController,
    required this.contactRepository,
  });

  @override
  void onInit() {
    super.onInit();

    // TODO remove debug
    print('CommonMessagingController initialization');
  }

  /// Executes connection controller's instance closing code if necessary.
  @override
  void onClose() {
    super.onClose();
  }

  // Public abstract methods, that are used for connection control and data transfer
  // are declared below.
  // Since this interactions are different for each connection type,
  // these public methods must be implementation in corresponding derived classes.

  /// Public method, used by MessagesController for initiate messaging connection.
  ///
  /// Should be implemented by override in the derived class.
  Future<void> initMessagingConnection({required String remoteId});

  /// Sends text message
  ///
  /// Should be implemented by override in the derived class.
  Future<void> sendTextMessage(
      {required String text, required String remoteCoreId});

  /// Sends binary message
  ///
  /// Should be implemented by override in the derived class.
  Future<void> sendBinaryMessage(
      {required Uint8List binary, required String remoteCoreId});

  // Public methods, that are used by derived classes independently of connection type,
  // are declared and implemented below.

  Future<void> setConnectivityOnline() async {
    await Future.delayed(const Duration(seconds: 2), () {
      connectivityStatus.value = DataChannelConnectivityStatus.online;
    });
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

    await sendTextMessage(
        text: jsonEncode(dataChannelMessageJson), remoteCoreId: remoteCoreId);
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
      if (currentState == null) {
        currentState = BinaryFileReceivingState(message.filename, message.meta);
        print('RECEIVER: New file transfer and State started');
      }
      currentState!.pendingMessages[message.chunkStart] = message;
      await HandleReceivedBinaryData(
              messagesRepo: messagesRepo, chatId: remoteCoreId)
          .execute(state: currentState!, remoteCoreId: remoteCoreId);
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
    DataChannelMessageModel channelMessage =
        DataChannelMessageModel.fromJson(receivedJson);
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
    MessageModel? _currentMsg = await messagesRepo.getMessageById(
        messageId: receivedMessage.messageId, chatId: chatId);
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
    DeleteMessageModel deleteMessage =
        DeleteMessageModel.fromJson(receivedDeleteJson);

    await messagesRepo.deleteMessages(
        messageIds: deleteMessage.messageIds, chatId: chatId);
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
      final receivedReactions =
          updateMessage.message.reactions.map((key, value) {
        ReactionModel? existingReaction =
            currentMessage.reactions[key] as ReactionModel?;
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
    ConfirmMessageModel confirmMessage =
        ConfirmMessageModel.fromJson(receivedconfirmJson);

    final String messageId = confirmMessage.messageId;
    if (confirmMessage.status == ConfirmMessageStatus.delivered) {
      MessageModel? currentMessage = await messagesRepo.getMessageById(
          messageId: messageId, chatId: chatId);

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
      final List<MessageModel> messages =
          await messagesRepo.getMessages(chatId);
      final index =
          messages.lastIndexWhere((element) => element.messageId == messageId);
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

  confirmReadMessages(
      {required String messageId, required String remoteCoreId}) async {
    await confirmMessageById(
      messageId: messageId,
      status: ConfirmMessageStatus.read,
      remoteCoreId: remoteCoreId,
    );
  }

  // creates a ChatModel and saves it to the chat history if it is not available
  // or updates the available chat
  createUserChatModel({required String sessioncid}) async {
    UserModel? userModel = await contactRepository.getContactById(sessioncid);

    ChatModel userChatModel = ChatModel(
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

  handleConnectionClose() {
    if (Get.currentRoute == Routes.MESSAGES) {
      Get.until((route) => Get.currentRoute != Routes.MESSAGES);
    }
  }
}
