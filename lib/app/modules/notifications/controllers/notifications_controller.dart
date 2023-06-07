import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';
import 'package:image_editor/image_editor.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../shared/utils/constants/notifications_constant.dart';
import '../../shared/utils/permission_flow.dart';

class NotificationsController extends GetxController {
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

    await awesomeNotifications.createNotification(
      content: notificationContent,
    );
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

  static Future<void> initializeNotificationsEventListeners() async {
    // Only after at least the action method is set, the notification events are delivered
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationsController.onActionReceivedMethod,
        onNotificationCreatedMethod: NotificationsController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod: NotificationsController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod: NotificationsController.onDismissActionReceivedMethod);
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
        break;

      case NOTIFICATIONS.callsChannelKey:
        break;

      default:
        break;
    }
  }
}
