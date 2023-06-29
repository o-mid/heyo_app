import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/list_notifier.dart';

import '../../shared/utils/constants/colors.dart';
import '../../shared/utils/constants/notifications_constant.dart';
import 'notifications_controller.dart';

class AppNotifications extends GetxController {
  RxBool isAppOnBackground = false.obs;
  RxBool isNotificationGranted = false.obs;

  @override
  void onInit() async {
    super.onInit();
  }

  initialize() async {
    await AwesomeNotifications().initialize(
        // set the icon to null if you want to use the default app icon
        'resource://drawable/icon',
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
            icon: 'resource://drawable/message',
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
            icon: 'resource://drawable/call',
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

  Future<void> initializeNotificationsEventListeners() async {
    // Only after at least the action method is set, the notification events are delivered
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: onActionReceivedMethod,
        onNotificationCreatedMethod: onNotificationCreatedMethod,
        onNotificationDisplayedMethod: onNotificationDisplayedMethod,
        onDismissActionReceivedMethod: onDismissActionReceivedMethod);
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

    // bool isSilentAction =  receivedAction.actionType == ActionType.SilentAction ||
    //     receivedAction.actionType == ActionType.SilentBackgroundAction;

    // SilentBackgroundAction runs on background thread and cannot show
    // UI/visual elements

    if (receivedAction.actionType != ActionType.SilentBackgroundAction) {
      // Get.snackbar(isSilentAction ? 'Silent action' : 'Action',
      //     'rec eived on ${(receivedAction.actionLifeCycle!)}');
    }
    final receivedActionPayload = receivedAction.payload;

    await Get.find<NotificationsController>().onActionReceivedMethod(
        ReceivedNotificationActionEvent(
            buttonKeyInput: receivedAction.buttonKeyInput,
            channelKey: receivedAction.channelKey,
            buttonKeyPressed: receivedAction.buttonKeyPressed,
            payload: receivedActionPayload));
  }

  Future<void> instantNotify({
    required int id,
    String? title,
    String? body,
  }) async {
    await _checkNotificationPermission();
    if (isNotificationGranted.value) {
      final AwesomeNotifications awesomeNotifications = AwesomeNotifications();

      await awesomeNotifications.createNotification(
        content: NotificationContent(
          id: id,
          title: "Instant Delivery",
          body: "Notification that delivers instantly on trigger.",
          channelKey: NOTIFICATIONS.messagesChannelKey,
        ),
      );
    }
  }

  Future<void> pushReceivedMessageNotify(
      {required String channelKey,
      required int id,
      String? title,
      String? body,
      String? groupKey,
      String? summary,
      String? icon,
      String? largeIcon,
      String? bigPicture,
      String? customSound,
      Map<String, String?>? payload,
      required String chatId}) async {
// pushes the notification only if the the receiver user is not at the chat screen with the sender of the message
    NotificationContent notificationContent = NotificationContent(
      id: id,
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
    );
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

  Future<void> pushReceivedCallNotify({
    required String channelKey,
    required int id,
    String? title,
    String? body,
  }) async {
    NotificationContent notificationContent = NotificationContent(
      id: id,
      channelKey: channelKey,
      title: title,
      body: body,
    );
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
}
