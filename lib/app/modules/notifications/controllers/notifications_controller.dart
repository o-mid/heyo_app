import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';
import 'package:permission_handler/permission_handler.dart';

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
              channelGroupKey: 'basic_channel_group',
              channelKey: 'basic_channel',
              channelName: 'Basic notifications',
              channelDescription: 'Notification channel for basic tests',
              defaultColor: Color(0xFF9D50DD),
              ledColor: Colors.white)
        ],
        // Channel groups are only visual and are not required
        channelGroups: [
          NotificationChannelGroup(
              channelGroupKey: 'basic_channel_group', channelGroupName: 'Basic group')
        ],
        debug: true);
    await _checkNotificationPermission();
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
          channelKey: 'basic_channel',
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

    // if (isNotificationGranted.value) {
    await awesomeNotifications.createNotification(
      content: notificationContent,
    );
    //  }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
