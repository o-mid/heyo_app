import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationsController extends GetxController {
  //TODO: Implement NotificationsController

  final count = 0.obs;
  @override
  void onInit() async {
    await initializeNotifications();
    super.onInit();
  }

  initializeNotifications() async {
    await AwesomeNotifications().initialize(
        // set the icon to null if you want to use the default app icon
        'resource://drawable/res_app_icon',
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
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
