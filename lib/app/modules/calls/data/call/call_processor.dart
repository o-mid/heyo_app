import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/data/call_requests_processor.dart';
import 'package:heyo/app/modules/calls/data/model/notification_call_model.dart';
import 'package:heyo/app/modules/shared/utils/extensions/map.extension.dart';

class CallProcessor {
  static int callNotificationId = 10;

  void setup({
    required DateTime? messageCreationTime,
    required Map<String, dynamic> data,
  }) {
    if (messageCreationTime != null) {
      _addNotificationCreationTimeToPayload(data, messageCreationTime);
    }
  }

  void process({
    required bool isBackgroundNotification,
    required Map<String, dynamic> data,
    required FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
  }) {
    final messageTime = DateTime.fromMillisecondsSinceEpoch(
      int.parse(data['dateTime'].toString()),
    );
    final diff = DateTime.now().millisecondsSinceEpoch -
        messageTime.millisecondsSinceEpoch;
    // Skip if more than 20 seconds
    if (diff > 20 * 1000) return;
    if (isBackgroundNotification) {
      _showNotificationWithActions(
        flutterLocalNotificationPlugin: flutterLocalNotificationsPlugin,
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
      _openIncomingCallPage(jsonEncode(data), flutterLocalNotificationsPlugin);
    }
  }

  Future<void> _showNotificationWithActions({
    required String channelName,
    required String title,
    required String body,
    required String payload,
    required List<AndroidNotificationAction> actions,
    required FlutterLocalNotificationsPlugin flutterLocalNotificationPlugin,
  }) async {
    final androidNotificationDetails = AndroidNotificationDetails(
      '0',
      channelName,
      fullScreenIntent: true,
      actions: actions,
      priority: Priority.high,
      importance: Importance.high,
      timeoutAfter: 20 * 1000,
    );
    final notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationPlugin.show(
      CallProcessor.callNotificationId,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  Future<void> _openIncomingCallPage(String payload,
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    final notificationContent =
        NotificationCallModel.fromJson(jsonDecode(payload));


    // cancel notification
    await flutterLocalNotificationsPlugin.cancel(callNotificationId);

    final callRequestsProcessor = Get.find<CallRequestsProcessor>();

    await callRequestsProcessor.onRequestReceived(
      notificationContent.content!.toJson(),
      notificationContent.messageFrom!,
      null,
    );
  }

  void _addNotificationCreationTimeToPayload(
      Map<String, dynamic> data, DateTime messageSent) {
    if (data['dateTime'] == null) {
      data.addToMap(
        'dateTime',
        messageSent.microsecondsSinceEpoch.toString(),
      );
    }
  }
}
