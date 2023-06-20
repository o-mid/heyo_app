// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_editor/image_editor.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';

import '../../../routes/app_pages.dart';
import '../../calls/incoming_call/controllers/incoming_call_controller.dart';
import '../../chats/data/providers/chat_history/chat_history_provider.dart';
import '../../chats/data/repos/chat_history/chat_history_abstract_repo.dart';
import '../../chats/data/repos/chat_history/chat_history_repo.dart';
import '../../messages/controllers/messages_controller.dart';
import '../../messages/data/models/reply_to_model.dart';
import '../../messages/data/provider/messages_provider.dart';
import '../../messages/data/repo/messages_abstract_repo.dart';
import '../../messages/data/repo/messages_repo.dart';
import '../../messages/data/usecases/send_message_usecase.dart';
import '../../messaging/controllers/common_messaging_controller.dart';
import '../../new_chat/data/models/user_model.dart';
import '../../shared/data/models/messages_view_arguments_model.dart';
import '../../shared/providers/database/app_database.dart';
import '../../shared/utils/constants/colors.dart';
import '../../shared/utils/constants/notifications_constant.dart';
import '../../shared/utils/permission_flow.dart';
import '../data/models/notifications_payload_model.dart';

class NotificationsController extends GetxController {
  final ChatHistoryLocalAbstractRepo chatHistoryRepo = ChatHistoryLocalRepo(
    chatHistoryProvider: ChatHistoryProvider(appDatabaseProvider: Get.find<AppDatabaseProvider>()),
  );
  final MessagesAbstractRepo messagesRepo = MessagesRepo(
    messagesProvider: MessagesProvider(
      appDatabaseProvider: Get.find(),
    ),
  );
  RxBool isNotificationGranted = false.obs;

  @override
  void onInit() async {
    await initializeNotifications();
    super.onInit();
  }

  initializeNotifications() async {
    await AwesomeNotifications().initialize(
        // set the icon to null if you want to use the default app icon
        null,
        [
          NotificationChannel(
            channelKey: NOTIFICATIONS.messagesChannelKey,
            channelName: NOTIFICATIONS.messagesChannelName,
            channelDescription: NOTIFICATIONS.messagesChannelDescription,
            defaultColor: NOTIFICATIONS.defaultColor,
            ledColor: NOTIFICATIONS.defaultColor,
            importance: NotificationImportance.Max,
            groupSort: GroupSort.Asc,
            groupAlertBehavior: GroupAlertBehavior.Children,
          ),
          NotificationChannel(
            channelKey: NOTIFICATIONS.callsChannelKey,
            channelName: NOTIFICATIONS.callsChannelName,
            channelDescription: NOTIFICATIONS.callsChannelDescription,
            defaultColor: NOTIFICATIONS.defaultColor,
            importance: NotificationImportance.Max,
            groupSort: GroupSort.Asc,
            groupAlertBehavior: GroupAlertBehavior.Children,
            ledColor: NOTIFICATIONS.defaultColor,
          )
        ],
        // Channel groups are only visual and are not required
        channelGroups: [
          // NotificationChannelGroup(
          //     channelGroupKey: 'basic_channel_group', channelGroupName: 'Basic group')
        ],
        debug: true);
    await _checkNotificationPermission();
    await initializeNotificationsEventListeners();
  }

  Future<void> instantNotify() async {
    await _checkNotificationPermission();
    if (isNotificationGranted.value) {
      final AwesomeNotifications awesomeNotifications = AwesomeNotifications();

      await awesomeNotifications.createNotification(
        content: NotificationContent(
          id: Random().nextInt(100),
          title: "Instant Delivery",
          body: "Notification that delivers instantly on trigger.",
          channelKey: NOTIFICATIONS.messagesChannelKey,
        ),
      );
    }
  }

  Future<void> _checkNotificationPermission() async {
    await AwesomeNotifications().isNotificationAllowed().then((isAllowed) async {
      if (!isAllowed) {
        isNotificationGranted.value =
            await AwesomeNotifications().requestPermissionToSendNotifications();
      } else {
        isNotificationGranted.value = true;
      }
    });
  }

  Future<void> receivedMessageNotify(
      {required NotificationContent notificationContent, required String chatId}) async {
// pushes the notification only if the the receiver user is not at the chat screen with the sender of the message

    if (Get.currentRoute == Routes.MESSAGES && Get.find<MessagesController>().chatId == chatId) {
      return;
    } else {
      await _checkNotificationPermission();
      final AwesomeNotifications awesomeNotifications = AwesomeNotifications();
      await awesomeNotifications.createNotification(content: notificationContent, actionButtons: [
        NotificationActionButton(
          key: MessagesActionButtons.reply.name,
          label: 'Reply Message',
          requireInputText: true,
          actionType: ActionType.Default,
          autoDismissible: true,
        ),
        NotificationActionButton(
          key: MessagesActionButtons.read.name,
          label: "Mark as Read",
          actionType: ActionType.Default,
          autoDismissible: true,
        )
      ]);
    }
  }

  Future<void> sendMessageNotify({required NotificationContent notificationContent}) async {
    await _checkNotificationPermission();
    final AwesomeNotifications awesomeNotifications = AwesomeNotifications();

    await awesomeNotifications.createNotification(
      content: notificationContent,
    );
  }

  Future<void> receivedCallNotify({
    required NotificationContent notificationContent,
  }) async {
    await _checkNotificationPermission();
    final AwesomeNotifications awesomeNotifications = AwesomeNotifications();

    await awesomeNotifications.createNotification(content: notificationContent, actionButtons: [
      NotificationActionButton(
          key: CallsActionButtons.answer.name,
          label: CallsActionButtons.answer.name.camelCase.toString(),
          requireInputText: false,
          color: Colors.green,
          autoDismissible: true,
          actionType: ActionType.Default),
      NotificationActionButton(
          key: CallsActionButtons.decline.name,
          label: CallsActionButtons.decline.name.camelCase.toString(),
          actionType: ActionType.DismissAction,
          color: COLORS.kStatesErrorColor,
          icon: Icons.call.toString(),
          autoDismissible: true)
    ]);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> initializeNotificationsEventListeners() async {
    // Only after at least the action method is set, the notification events are delivered
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: onActionReceivedMethod,
        onNotificationCreatedMethod: onNotificationCreatedMethod,
        onNotificationDisplayedMethod: onNotificationDisplayedMethod,
        onDismissActionReceivedMethod: onDismissActionReceivedMethod);
  }

  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(ReceivedNotification receivedNotification) async {
    // Get.snackbar("Notification created", '${receivedNotification.createdLifeCycle!}');
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    //   Get.snackbar("Notification displayed", '${receivedNotification.createdLifeCycle!}');
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(ReceivedAction receivedAction) async {
    // Get.snackbar("Notification dismissed", '${receivedAction.dismissedLifeCycle!}');
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    // Always ensure that all plugins was initialized
    WidgetsFlutterBinding.ensureInitialized();

    // bool isSilentAction = receivedAction.actionType == ActionType.SilentAction ||
    //     receivedAction.actionType == ActionType.SilentBackgroundAction;

    // SilentBackgroundAction runs on background thread and cannot show
    // UI/visual elements
    if (receivedAction.actionType != ActionType.SilentBackgroundAction) {
      // Get.snackbar(isSilentAction ? 'Silent action' : 'Action',
      //     'received on ${(receivedAction.actionLifeCycle!)}');
    }

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

  static Future<void> receiveMessagesNotificationAction(
    ReceivedAction receivedAction,
  ) async {
    if (receivedAction.buttonKeyPressed == MessagesActionButtons.reply.name) {
      String message = receivedAction.buttonKeyInput;
      // send the reply of the message received
      if (receivedAction.payload != null) {
        final payload =
            NotificationsPayloadModel.fromJson(receivedAction.payload as Map<String, dynamic>);
        final userChatModel =
            await NotificationsController().chatHistoryRepo.getChat(payload.chatId);
        if (userChatModel != null) {
          // Get.find<MessagesController>().initMessagingConnection();
          SendMessage().execute(
              sendMessageType: SendMessageType.text(
                text: message,
                replyTo: ReplyToModel(
                  repliedToMessageId: payload.messageId,
                  repliedToName: payload.senderName,
                  repliedToMessage: payload.replyMsg,
                ),
                chatId: payload.chatId,
              ),
              remoteCoreId: userChatModel.coreId);
        }
      }
    } else if (receivedAction.buttonKeyPressed == MessagesActionButtons.read.name) {
      // mark the message as read
      if (receivedAction.payload != null) {
        final payload =
            NotificationsPayloadModel.fromJson(receivedAction.payload as Map<String, dynamic>);

        final userChatModel =
            await NotificationsController().chatHistoryRepo.getChat(payload.chatId);

        if (userChatModel != null) {
          // sends the confirm message to the remote side
          await Get.find<CommonMessagingConnectionController>().confirmReadMessages(
              messageId: payload.messageId, remoteCoreId: userChatModel.coreId);
          // mark the message as read in the local database
          await NotificationsController()
              .messagesRepo
              .markMessagesAsRead(lastReadmessageId: payload.messageId, chatId: payload.chatId);
          // update the chat history in the local database
          await NotificationsController().chatHistoryRepo.updateChat(userChatModel.copyWith(
                lastReadMessageId: payload.messageId,
                notificationCount: 0,
              ));
        }
      }
    } else {
      // navigate to the Messages screen of user
      if (receivedAction.payload != null) {
        final payload =
            NotificationsPayloadModel.fromJson(receivedAction.payload as Map<String, dynamic>);
        final userChatModel =
            await NotificationsController().chatHistoryRepo.getChat(payload.chatId);
        if (userChatModel != null) {
          Get.toNamed(
            Routes.MESSAGES,
            arguments: MessagesViewArgumentsModel(
              user: UserModel(
                iconUrl: userChatModel.icon,
                name: userChatModel.name,
                walletAddress: userChatModel.coreId,
                coreId: userChatModel.coreId,
                isOnline: userChatModel.isOnline,
              ),
            ),
          );
        }
      }
    }
  }

  static Future<void> receiveCallsNotificationAction(
    ReceivedAction receivedAction,
  ) async {
    if (receivedAction.buttonKeyPressed == CallsActionButtons.answer.name) {
      Get.find<IncomingCallController>().acceptCall();
    } else if (receivedAction.buttonKeyPressed == CallsActionButtons.decline.name) {
      Get.find<IncomingCallController>().declineCall();
    }
  }
}
