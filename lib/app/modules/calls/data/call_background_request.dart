import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:heyo/app/modules/calls/data/notification_processor.dart';
import 'package:heyo/main.dart';


@pragma('vm:entry-point')
Future<void> onBackgroundMessage(RemoteMessage message) async {
  NotificationProcessor.process(
    message.sentTime,
    jsonEncode(message.data),
    flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
    isBackgroundNotification: true,
  );
}

Future<void> onMessageReceived(
  RemoteMessage message, {
  required bool isFromBackground,
  required FlutterLocalNotificationsPlugin flutterLocalNotification,
}) async {
  NotificationProcessor.process(
    message.sentTime,
    jsonEncode(message.data),
    flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
    isBackgroundNotification: isFromBackground,
  );
}

