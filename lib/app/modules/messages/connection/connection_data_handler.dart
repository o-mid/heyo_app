import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:heyo/app/modules/messages/connection/models/models.dart';
import 'package:heyo/app/modules/messages/data/models/messages/image_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/text_message_model.dart';
import 'package:heyo/app/modules/messages/utils/extensions/messageModel.extension.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model/user_model.dart';
import 'package:heyo/app/modules/notifications/data/models/notifications_payload_model.dart';
import 'package:heyo/app/modules/shared/data/models/messaging_participant_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/notifications_constant.dart';
import 'package:heyo/app/modules/shared/utils/extensions/core_id.extension.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/mocks/random_avatar_icon.dart';
import 'package:tuple/tuple.dart';

import '../../chats/data/models/chat_model.dart';
import '../../chats/data/repos/chat_history/chat_history_abstract_repo.dart';
import '../../shared/data/repository/account/account_repository.dart';
import '../data/models/messages/confirm_message_model.dart';
import '../data/models/messages/delete_message_model.dart';
import '../data/models/messages/message_model.dart';
import '../data/models/messages/update_message_model.dart';
import '../data/models/reaction_model.dart';
import '../data/repo/messages_repo.dart';
import '../utils/message_from_json.dart';
import '../../notifications/controllers/notifications_controller.dart';
import '../../../../modules/features/contact/data/local_contact_repo.dart';
import 'models/data_channel_message_model.dart';

class DataHandler {
  final MessagesRepo messagesRepo;
  final ChatHistoryLocalAbstractRepo chatHistoryRepo;
  final NotificationsController notificationsController;
  final LocalContactRepo contactRepository;
  final AccountRepository accountInfoRepo;

  DataHandler({
    required this.messagesRepo,
    required this.chatHistoryRepo,
    required this.notificationsController,
    required this.contactRepository,
    required this.accountInfoRepo,
  });

  createUserChatModel({required String sessioncid}) async {
    UserModel? userModel = await contactRepository.getContactById(sessioncid);

    final userChatModel = ChatModel(
      id: sessioncid,
      name: (userModel == null)
          ? "${sessioncid.characters.take(4).string}...${sessioncid.characters.takeLast(4).string}"
          : userModel.name,
      lastMessage: "",
      lastReadMessageId: "",
      timestamp: DateTime.now(),
      participants: [
        MessagingParticipantModel(
          coreId: sessioncid,
          chatId: sessioncid,
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

  Future<void> createChatModel({
    required String chatId,
    required String chatName,
    required List<String> remoteCoreIds,
  }) async {
    final currentChatModel = await chatHistoryRepo.getChat(chatId);

    var isGroupChat = false;

    final selfCoreId = await accountInfoRepo.getUserAddress();

    if (remoteCoreIds.contains(selfCoreId)) {
      remoteCoreIds.remove(selfCoreId);
    }

    if (remoteCoreIds.length > 1) {
      isGroupChat = true;
      if (chatName == "" && currentChatModel != null) {
        chatName = currentChatModel.name;
      }
    } else {
      final userModel =
          await contactRepository.getContactById(remoteCoreIds.first);
      chatName = (userModel == null)
          ? '${remoteCoreIds.first.characters.take(4).string}...${remoteCoreIds.first.characters.takeLast(4).string}'
          : userModel.name;
    }

    remoteCoreIds.add(selfCoreId!);
    final chatModel = ChatModel(
      id: chatId,
      name: chatName,
      lastMessage: "",
      lastReadMessageId: "",
      timestamp: DateTime.now(),
      isGroupChat: isGroupChat,
      participants: remoteCoreIds
          .map((e) => MessagingParticipantModel(coreId: e, chatId: chatId))
          .toList(),
    );

    if (currentChatModel == null) {
      await chatHistoryRepo.addChatToHistory(chatModel);
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
    required String coreId,
    required bool isGroupChat,
    required String chatName,
    required List<String> remoteCoreIds,
  }) async {
    MessageModel receivedMessage = messageFromJson(receivedMessageJson);
    MessageModel? _currentMsg = await messagesRepo.getMessageById(
        messageId: receivedMessage.messageId, chatId: chatId);

    bool isNewMessage = (_currentMsg == null);
    UserModel? contact = await contactRepository.getContactById(coreId);

    if (isNewMessage) {
      await messagesRepo.createMessage(
        message: receivedMessage.copyWith(
          isFromMe: false,
          status: receivedMessage.status.deliveredStatus(),
          senderAvatar: coreId,
          senderName: contact?.name,
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
      chatName: chatName,
      remoteCoreIds: remoteCoreIds,
    );

    return Tuple3(
      receivedMessage.messageId,
      ConfirmMessageStatus.delivered,
      chatId,
    );
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
    final localCoreID = await accountInfoRepo.getUserAddress() ?? "";

    final MessageModel? currentMessage = await messagesRepo.getMessageById(
      messageId: updateMessage.message.messageId,
      chatId: chatId,
    );

    if (currentMessage != null) {
      final receivedReactions =
          updateMessage.message.reactions.map((key, value) {
        ReactionModel? existingReaction =
            currentMessage.reactions[key] as ReactionModel?;
        bool isReactedByMe = value.users.contains(localCoreID);

        if (existingReaction is ReactionModel) {
          final newValue = value.copyWith(
            isReactedByMe: isReactedByMe,
          );
          return MapEntry(key, newValue);
        }
        return MapEntry(
          key,
          value.copyWith(isReactedByMe: isReactedByMe),
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

      if (index != -1) {
        final messagesToUpdate = messages
            .sublist(0, index + 1)
            .where(
              (element) =>
                  element.isFromMe == true &&
                  (element.status == MessageStatus.delivered),
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
    final bigPicture = await _getBigPicture(receivedMessage, chatId);

    final payload =
        _createNotificationPayload(receivedMessage, chatId, senderName);

    await notificationsController.receivedMessageNotify(
      chatId: chatId,
      channelKey: NOTIFICATIONS.messagesChannelKey,
      title: senderName,
      body: receivedMessage.getMessageContent(),
      bigPicture: bigPicture,
      payload: payload.toJson(),
    );
  }

  Future<String?> _getBigPicture(MessageModel message, String chatId) async {
    if (message.type == MessageContentType.image) {
      return ((await messagesRepo.getMessageById(
        messageId: message.messageId,
        chatId: chatId,
      ))! as ImageMessageModel)
          .url;
    }
    return null;
  }

  NotificationsPayloadModel _createNotificationPayload(
      MessageModel receivedMessage, String chatId, String senderName) {
    return NotificationsPayloadModel(
      chatId: chatId,
      messageId: receivedMessage.messageId,
      senderName: senderName,
      replyMsg: receivedMessage.getMessageContent(),
    );
  }

  Future<void> updateChatRepoAndNotify({
    required MessageModel receivedMessage,
    required String chatId,
    required bool notify,
    required String chatName,
    required List<String> remoteCoreIds,
  }) async {
    bool isGroupChat = false;
    ChatModel? chatmodel = await chatHistoryRepo.getChat(chatId);

    int unReadMessagesCount = await messagesRepo.getUnReadMessagesCount(chatId);

    if (remoteCoreIds.length > 2) {
      isGroupChat = true;
    } else {
      isGroupChat = false;
    }

    chatmodel = chatmodel?.copyWith(
      lastMessage: receivedMessage.getMessageContent(),
      notificationCount: unReadMessagesCount,
      id: chatId,
      timestamp: receivedMessage.timestamp.toLocal(),
      isGroupChat: isGroupChat,
      name: isGroupChat ? chatName : chatmodel.name,
      participants: remoteCoreIds
          .map((e) => MessagingParticipantModel(coreId: e, chatId: chatId))
          .toList(),
    );

    if (chatmodel != null) {
      await chatHistoryRepo.updateChat(chatmodel);
    }

    if (notify) {
      print("notifyyyyy $chatId");

      await notifyReceivedMessage(
        receivedMessage: receivedMessage,
        chatId: chatId,
        senderName: isGroupChat ? chatName : chatmodel!.name,
      );
    }
  }

  Future<String> getMessageJsonEncode({
    required String messageId,
    required ConfirmMessageStatus status,
    required List<String> remoteCoreIds,
    required ChatId chatId,
  }) async {
    final confirmMessageJson = ConfirmMessageModel(
      messageId: messageId,
      status: status,
    ).toJson();
    final dataChannelMessage = WrappedMessageModel(
      message: confirmMessageJson,
      dataChannelMessagetype: MessageType.confirm,
      chatId: chatId,
      chatName: await getChatName(chatId: chatId),
      remoteCoreIds: remoteCoreIds,
    );
    final dataChannelMessageJson = dataChannelMessage.toJson();

    return jsonEncode(dataChannelMessageJson);
  }

  Future<String> getChatName({required String chatId}) async {
    final chatModel = await chatHistoryRepo.getChat(chatId);

    if (chatModel != null) {
      return chatModel.name;
    } else {
      return "";
    }
  }

  Future<String> getSelfCoreId() async {
    final selfCoreId = await accountInfoRepo.getUserAddress();
    return selfCoreId ?? '';
  }
}
