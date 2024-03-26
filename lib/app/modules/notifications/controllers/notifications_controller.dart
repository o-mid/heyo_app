// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/data/message_processor.dart' as message_processor;
import 'package:heyo/app/modules/notifications/controllers/app_notifications.dart';
import 'package:heyo/app/modules/shared/data/models/messaging_participant_model.dart';

import '../../../routes/app_pages.dart';
import '../../../../modules/call/presentation/incoming_call/incoming_call_controller.dart';
import '../../chats/data/providers/chat_history/chat_history_provider.dart';
import '../../../../modules/features/chats/domain/chat_history_repo.dart';
import '../../../../modules/features/chats/data/local_chat_history_repo.dart';
import '../../messages/controllers/messages_controller.dart';
import '../../messages/data/models/reply_to_model.dart';
import '../../messages/data/provider/messages_provider.dart';
import '../../messages/data/repo/messages_abstract_repo.dart';
import '../../messages/data/repo/messages_repo.dart';
import '../../messages/data/usecases/send_message_usecase.dart';
import '../../shared/data/models/messages_view_arguments_model.dart';
import '../../shared/data/providers/database/app_database.dart';
import '../../shared/utils/constants/colors.dart';
import '../../shared/utils/constants/notifications_constant.dart';
import '../../shared/utils/permission_flow.dart';
import '../data/models/notifications_payload_model.dart';

class NotificationsController extends GetxController with WidgetsBindingObserver {
  NotificationsController({
    required this.appNotifications,
    required this.chatHistoryRepo,
  });

  final AppNotifications appNotifications;
  final ChatHistoryRepo chatHistoryRepo;
  final MessagesAbstractRepo messagesRepo = MessagesRepo(
    messagesProvider: MessagesProvider(
      appDatabaseProvider: Get.find(),
    ),
  );

  RxBool isAppOnBackground = false.obs;

  @override
  void onInit() async {
    await initializeNotifications();
    WidgetsBinding.instance.addObserver(this);

    super.onInit();
  }

  initializeNotifications() async {
    await appNotifications.initialize();
  }

  Future<void> instantNotify({
    String? title,
    String? body,
  }) async {
    appNotifications.instantNotify(
      id: Random().nextInt(100),
      title: title,
      body: body,
    );
  }

  Future<void> receivedMessageNotify({
    required String channelKey,
    String? title,
    String? body,
    String? groupKey,
    String? summary,
    String? icon,
    String? largeIcon,
    String? bigPicture,
    String? customSound,
    Map<String, String?>? payload,
    required String chatId,
  }) async {
// pushes the notification only if the the receiver user is not at the chat screen with the sender of the message

    if (Get.currentRoute == Routes.MESSAGES &&
        Get.find<MessagesController>().chatId == chatId &&
        !isAppOnBackground.value) {
      return;
    } else {
      await appNotifications.pushReceivedMessageNotify(
        id: Random().nextInt(1000),
        channelKey: channelKey,
        title: title,
        body: body,
        groupKey: groupKey,
        summary: summary,
        icon: icon,
        largeIcon: largeIcon,
        bigPicture: bigPicture,
        customSound: customSound,
        payload: payload,
        chatId: chatId,
      );
    }
  }

  Future<void> receivedCallNotify({
    String? title,
    String? body,
  }) async {
    // if (Get.currentRoute == Routes.INCOMING_CALL || !isAppOnBackground.value) {
    //   return;
    // } else {
    await appNotifications.pushReceivedCallNotify(
      id: Random().nextInt(1000),
      title: title,
      body: body,
    );
    //}
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);

    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      // app is inactive
      // Apps in this state should assume that they may be [paused] at any time.
      isAppOnBackground.value = true;
    } else if (state == AppLifecycleState.paused) {
      isAppOnBackground.value = true;
      print('app is in background');
      // app is in background
    } else if (state == AppLifecycleState.resumed) {
      print('app is resumed');
      isAppOnBackground.value = false;
      // app is resumed
    }
  }

  onActionReceivedMethod(ReceivedNotificationActionEvent receivedAction) async {
    switch (receivedAction.channelKey) {
      case NOTIFICATIONS.messagesChannelKey:
        await receiveMessagesNotificationAction(receivedAction);

        break;

      case NOTIFICATIONS.callsChannelKey:
        await receiveCallsNotificationAction(receivedAction);
        break;

      default:
        break;
    }
  }

  Future<void> receiveMessagesNotificationAction(
    ReceivedNotificationActionEvent receivedAction,
  ) async {
    if (receivedAction.buttonKeyPressed == MessagesActionButtons.reply.name) {
      String message = receivedAction.buttonKeyInput;
      // send the reply of the message received
      if (receivedAction.payload != null) {
        final payload =
            NotificationsPayloadModel.fromJson(receivedAction.payload as Map<String, dynamic>);
        print(payload);
        print(payload);
        final userChatModel = await chatHistoryRepo.getChat(payload.chatId);
        if (userChatModel != null) {
          // Get.find<MessagesController>().initMessagingConnection();
          //TODO farzam reply
          /*  await sendMessageUseCase.execute(
              sendMessageType: SendMessageType.text(
                text: message,
                replyTo: ReplyToModel(
                  repliedToMessageId: payload.messageId,
                  repliedToName: payload.senderName,
                  repliedToMessage: payload.replyMsg,
                ),
                chatId: payload.chatId,
              ),
              remoteCoreId: userChatModel.id);*/
        }
      }
    } else if (receivedAction.buttonKeyPressed == MessagesActionButtons.read.name) {
      // mark the message as read
      if (receivedAction.payload != null) {
        final payload =
            NotificationsPayloadModel.fromJson(receivedAction.payload as Map<String, dynamic>);

        final userChatModel = await chatHistoryRepo.getChat(payload.chatId);

        if (userChatModel != null) {
          // sends the confirm message to the remote side
          //todo farzam toggle read
          /*await Get.find<UnifiedConnectionController>().toggleMessageReadConfirm(
              messageId: payload.messageId, remoteCoreId: userChatModel.id);*/
          // mark the message as read in the local database
          await messagesRepo.markMessagesAsRead(
            lastReadmessageId: payload.messageId,
            chatId: payload.chatId,
          );
          // update the chat history in the local database
          await chatHistoryRepo.updateChat(
            userChatModel.copyWith(
              lastReadMessageId: payload.messageId,
              notificationCount: 0,
            ),
          );
        }
      }
    } else {
      // navigate to the Messages screen of user
      if (receivedAction.payload != null) {
        final payload =
            NotificationsPayloadModel.fromJson(receivedAction.payload as Map<String, dynamic>);
        final userChatModel = await chatHistoryRepo.getChat(payload.chatId);
        if (userChatModel != null) {
          await Get.toNamed(
            Routes.MESSAGES,
            arguments: MessagesViewArgumentsModel(
              participants: userChatModel.participants,
              chatName: userChatModel.name,
            ),
          );
        }
      }
    }
  }

  static Future<void> receiveCallsNotificationAction(
    ReceivedNotificationActionEvent receivedAction,
  ) async {
    if (receivedAction.buttonKeyPressed == CallsActionButtons.answer.name) {
      Get.find<IncomingCallController>().acceptCall();
    } else if (receivedAction.buttonKeyPressed == CallsActionButtons.decline.name) {
      Get.find<IncomingCallController>().declineCall();
    }
  }
}
