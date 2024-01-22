import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:heyo/app/modules/calls/data/call/call_processor.dart';

class NotificationProcessor {
  static void process(
    DateTime? messageSent,
    String rawData, {
    required FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    required bool isBackgroundNotification,
  }) {
    final data = jsonDecode(rawData) as Map<String, dynamic>;
    var messageCreationTime = messageSent;
    if (data['dateTime'] != null) {
      messageCreationTime = DateTime.fromMillisecondsSinceEpoch(
          int.parse(data['dateTime'].toString()));
    }

    print("NotificationProcessor data: $data");
    switch (data['notificationType']) {
      case 'CALL':
        final callProcessor = CallProcessor();
        callProcessor.setup(
          messageCreationTime: messageCreationTime,
          data: data,
        );
        callProcessor.process(
          isBackgroundNotification: isBackgroundNotification,
          data: data,
          flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
        );
      default:
        {}
    }
  }
}
