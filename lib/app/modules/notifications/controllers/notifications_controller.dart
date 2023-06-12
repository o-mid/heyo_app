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
import '../../chats/data/providers/chat_history/chat_history_provider.dart';
import '../../chats/data/repos/chat_history/chat_history_abstract_repo.dart';
import '../../chats/data/repos/chat_history/chat_history_repo.dart';
import '../../messages/controllers/messages_controller.dart';
import '../../messages/data/models/reply_to_model.dart';
import '../../messages/data/usecases/send_message_usecase.dart';
import '../../new_chat/data/models/user_model.dart';
import '../../shared/data/models/messages_view_arguments_model.dart';
import '../../shared/providers/database/app_database.dart';
import '../../shared/utils/constants/notifications_constant.dart';
import '../../shared/utils/permission_flow.dart';

class NotificationsController extends GetxController {
  final ChatHistoryLocalAbstractRepo chatHistoryRepo = ChatHistoryLocalRepo(
    chatHistoryProvider: ChatHistoryProvider(appDatabaseProvider: Get.find<AppDatabaseProvider>()),
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

            //icon: Assets.png.chain.path,
          ),
          NotificationChannel(
              channelKey: NOTIFICATIONS.callsChannelKey,
              channelName: NOTIFICATIONS.callsChannelName,
              channelDescription: NOTIFICATIONS.callsChannelDescription,
              defaultColor: NOTIFICATIONS.defaultColor,
              ledColor: NOTIFICATIONS.defaultColor)
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

  Future<void> receivedMessageNotify({required NotificationContent notificationContent}) async {
    await _checkNotificationPermission();
    final AwesomeNotifications awesomeNotifications = AwesomeNotifications();

    await awesomeNotifications.createNotification(content: notificationContent, actionButtons: [
      NotificationActionButton(
          key: MessagesActionButtons.redirect.name,
          label: MessagesActionButtons.redirect.name,
          actionType: ActionType.Default),
      NotificationActionButton(
          key: MessagesActionButtons.reply.name,
          label: 'Reply Message',
          requireInputText: true,
          actionType: ActionType.SilentAction),
      NotificationActionButton(
          key: MessagesActionButtons.dismiss.name,
          label: MessagesActionButtons.dismiss.name,
          actionType: ActionType.DismissAction,
          isDangerousOption: true)
    ]);
  }

  Future<void> sendMessageNotify({required NotificationContent notificationContent}) async {
    await _checkNotificationPermission();
    final AwesomeNotifications awesomeNotifications = AwesomeNotifications();

    await awesomeNotifications.createNotification(
      content: notificationContent,
    );
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
    //   Get.snackbar("Notification created", '${receivedNotification.createdLifeCycle!}');
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
    Get.snackbar("Notification dismissed", '${receivedAction.dismissedLifeCycle!}');
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    // Always ensure that all plugins was initialized
    WidgetsFlutterBinding.ensureInitialized();

    bool isSilentAction = receivedAction.actionType == ActionType.SilentAction ||
        receivedAction.actionType == ActionType.SilentBackgroundAction;

    // SilentBackgroundAction runs on background thread and cannot show
    // UI/visual elements
    if (receivedAction.actionType != ActionType.SilentBackgroundAction) {
      Get.snackbar(isSilentAction ? 'Silent action' : 'Action',
          'received on ${(receivedAction.actionLifeCycle!)}');
    }

    switch (receivedAction.channelKey) {
      case NOTIFICATIONS.messagesChannelKey:
        await receiveMessagesNotificationAction(receivedAction);

        break;

      case NOTIFICATIONS.callsChannelKey:
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
      if (receivedAction.payload?["chatId"] != null) {
        final userChatModel = await NotificationsController()
            .chatHistoryRepo
            .getChat(receivedAction.payload!["chatId"]!);
        if (userChatModel != null) {
          // Get.find<MessagesController>().initMessagingConnection();
          SendMessage().execute(
              sendMessageType: SendMessageType.text(
                text: message,
                replyTo: null,
                // replyTo: ReplyToModel(
                //   repliedToMessageId: msg.messageId,
                //   repliedToName: msg.senderName,
                //   repliedToMessage: replyMsg,
                // ),
                chatId: receivedAction.payload!["chatId"]!,
              ),
              remoteCoreId: userChatModel.coreId);
        }
      } else {
        // navigate to the Messages screen of user
        if (receivedAction.payload?["chatId"] != null) {
          final userChatModel = await NotificationsController()
              .chatHistoryRepo
              .getChat(receivedAction.payload!["chatId"]!);
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
  }
}
