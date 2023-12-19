import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:heyo/app/modules/messages/data/models/messages/image_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/text_message_model.dart';
import 'package:heyo/app/modules/notifications/data/models/notifications_payload_model.dart';
import 'package:heyo/app/modules/shared/data/models/messaging_participant_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/notifications_constant.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/mocks/random_avatar_icon.dart';
import 'package:tuple/tuple.dart';

import '../../chats/data/models/chat_model.dart';
import '../../chats/data/repos/chat_history/chat_history_abstract_repo.dart';
import '../data/models/messages/confirm_message_model.dart';
import '../data/models/messages/delete_message_model.dart';
import '../data/models/messages/message_model.dart';
import '../data/models/messages/update_message_model.dart';
import '../data/models/reaction_model.dart';
import '../data/repo/messages_repo.dart';
import '../utils/message_from_json.dart';
import '../../new_chat/data/models/user_model.dart';
import '../../notifications/controllers/notifications_controller.dart';
import '../../shared/data/repository/contact_repository.dart';
import 'models/data_channel_message_model.dart';

class DataHandler {
  final MessagesRepo messagesRepo;
  final ChatHistoryLocalAbstractRepo chatHistoryRepo;
  final NotificationsController notificationsController;
  final ContactRepository contactRepository;

  DataHandler({
    required this.messagesRepo,
    required this.chatHistoryRepo,
    required this.notificationsController,
    required this.contactRepository,
  });

  createUserChatModel({required String sessioncid}) async {
    UserModel? userModel = await contactRepository.getContactById(sessioncid);

    final userChatModel = ChatModel(
      id: sessioncid,
      isOnline: true,
      name: (userModel == null)
          ? "${sessioncid.characters.take(4).string}...${sessioncid.characters.takeLast(4).string}"
          : userModel.name,
      lastMessage: "",
      lastReadMessageId: "",
      isVerified: true,
      timestamp: DateTime.now(),
      participants: [
        MessagingParticipantModel(
          coreId: sessioncid,
        ),
      ],
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

  /* Future<void> handleReceivedBinaryData({
    required String remoteCoreId,
    required BinaryFileReceivingState currentBinaryState,
  }) async {
    await HandleReceivedBinaryData(messagesRepo: messagesRepo, chatId: remoteCoreId)
        .execute(state: currentBinaryState, remoteCoreId: remoteCoreId);
  }*/

  Future<Tuple3<String, ConfirmMessageStatus, String>> saveReceivedMessage({
    required Map<String, dynamic> receivedMessageJson,
    required String chatId,
  }) async {
    MessageModel receivedMessage = messageFromJson(receivedMessageJson);
    MessageModel? _currentMsg =
        await messagesRepo.getMessageById(messageId: receivedMessage.messageId, chatId: chatId);

    bool isNewMessage = (_currentMsg == null);

    if (isNewMessage) {
      await messagesRepo.createMessage(
        message: receivedMessage.copyWith(
          isFromMe: false,
          status: receivedMessage.status.deliveredStatus(),
        ),
        chatId: chatId,
      );
    } else {
      print('Message already exists');
      await messagesRepo.updateMessage(
        message: receivedMessage.copyWith(
          isFromMe: false,
          status: receivedMessage.status.deliveredStatus(),
        ),
        chatId: chatId,
      );
    }

    await updateChatRepoAndNotify(
      receivedMessage: receivedMessage,
      chatId: chatId,
      notify: isNewMessage,
    );

    return Tuple3(receivedMessage.messageId, ConfirmMessageStatus.delivered, chatId);
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
    ChatModel? userChatmodel = await chatHistoryRepo.getChat(chatId);

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
      await chatHistoryRepo.updateChat(userChatmodel);
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

  Future<String> getMessageJsonEncode({
    required String messageId,
    required ConfirmMessageStatus status,
    required String remoteCoreId,
  }) async {
    final confirmMessageJson = ConfirmMessageModel(
      messageId: messageId,
      status: status,
    ).toJson();
    final dataChannelMessage = WrappedMessageModel(
      message: confirmMessageJson,
      dataChannelMessagetype: MessageType.confirm,
    );
    final dataChannelMessageJson = dataChannelMessage.toJson();

    return jsonEncode(dataChannelMessageJson);
  }
}
