import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/data/call_requests_processor.dart';
import 'package:heyo/app/modules/calls/data/model/notification_call_model.dart';
import 'package:heyo/app/modules/shared/data/models/incoming_call_view_arguments.dart';
import 'package:heyo/app/routes/app_pages.dart';
import 'package:heyo/main.dart';

class NotificationProcessor {
  static void process(
    DateTime? messageSent,
    String rawData, {
    required FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    required bool isBackgroundNotification,
  }) {
    final data = jsonDecode(rawData) as Map<String, dynamic>;
    print("NotificationProcessor data: $data");
    switch (data['notificationType']) {
      case 'CALL':
        processCallNotification(
          messageSent,
          data,
          isBackgroundNotification: isBackgroundNotification,
        );
      default:
        {}
    }
  }

  static void processCallNotification(
    DateTime? messageSent,
    Map<String, dynamic> data, {
    required bool isBackgroundNotification,
  }) {
    if (messageSent != null) {
      final diff = DateTime.now().millisecondsSinceEpoch -
          messageSent.millisecondsSinceEpoch;
      //Skip if more than 20 seconds
      if (diff > 20 * 1000) return;
    }

    if (isBackgroundNotification) {
      showNotificationWithActions(
        channelName: 'Calls',
        title: 'Heyo',
        body: 'Incoming Call from Heyo',
        actions: [
          AndroidNotificationAction('1', 'Accept', showsUserInterface: true),
          AndroidNotificationAction('2', 'Deny')
        ],
        payload: jsonEncode(data),
      );
    } else {
      openIncomingCallPage(jsonEncode(data));
    }
  }

  static Future<void> showNotificationWithActions(
      {required String channelName,
      required String title,
      required String body,
      required String payload,
      required List<AndroidNotificationAction> actions}) async {
    final androidNotificationDetails = AndroidNotificationDetails(
      '0',
      channelName,
      ongoing: true,
      fullScreenIntent: true,
      actions: actions,
      priority: Priority.high,
      importance: Importance.high,
    );
    final notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
      1,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  static Future<void> openIncomingCallPage(String payload) async {
    final notificationContent =
        NotificationCallModel.fromJson(jsonDecode(payload));

    print("openIncomingCallPage: payload: $payload");

    final callRequestsProcessor = Get.find<CallRequestsProcessor>();
    print(
        "openIncomingCallPage: ${notificationContent.content.toString()} : ${notificationContent.content!.toJson()} : ${notificationContent.messageFrom}");
    await callRequestsProcessor.onRequestReceived(
      notificationContent.content!.toJson(),
      notificationContent.messageFrom!,
      null,
    );
  }
}
