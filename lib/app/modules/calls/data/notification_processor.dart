import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:heyo/app/modules/calls/data/call/call_notification_processor.dart';

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
        processCall(
          flutterLocalNotificationsPlugin,
          data,
          isBackgroundNotification,
        );
      default:
        {}
    }
  }

  static void processCall(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    Map<String, dynamic> data,
    bool isBackgroundNotification,
  ) {
    CallProcessor().process(
      isBackgroundNotification: isBackgroundNotification,
      data: data,
      flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
    );
  }
}
