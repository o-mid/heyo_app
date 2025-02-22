import 'dart:convert';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/utils/constants/notifications_constant.dart';
import 'package:heyo/app/modules/shared/utils/extensions/map.extension.dart';
import 'package:heyo/app/routes/app_pages.dart';
import 'package:heyo/modules/call/data/call_requests_processor.dart';
import 'package:heyo/modules/call/data/model/notification_call_model.dart';

class CallProcessor {
  static int callNotificationId = 10;

  bool isExpired(DateTime? messageCreated) {
    if (messageCreated != null) {
      final diff = DateTime.now().millisecondsSinceEpoch -
          messageCreated!.millisecondsSinceEpoch;
      // Skip if more than 20 seconds
      if (diff > 20 * 1000) return true;
    }
    return false;
  }

  void process({
    required bool isBackgroundNotification,
    required Map<String, dynamic> data,
    required FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
  }) {
    final callData = NotificationCallModel.fromJson(data);

    print("CALL Notification : $isBackgroundNotification");
    if ([Routes.INCOMING_CALL, Routes.CALL].contains(Get.currentRoute)) {
      /// could be moved to call requests processor
      /// in future, we have to show a missed call if caller is different from
      /// current one
      return;
    }
    if (isExpired(callData.content!.dateTime)) {
      /// could be moved to call requests processor
      _showMissedCall(callData, flutterLocalNotificationsPlugin);
      return;
    }

    if (isBackgroundNotification && Platform.isAndroid) {
      /// could be moved to call requests processor
      _showIncomingCallNotification(flutterLocalNotificationsPlugin, callData);
      return;
    }

    _openIncomingCallPage(callData, flutterLocalNotificationsPlugin);
  }

  Future<void> _showNotification({
    required String id,
    required String channelName,
    required String title,
    required String body,
    required String payload,
    required List<AndroidNotificationAction> actions,
    required FlutterLocalNotificationsPlugin flutterLocalNotificationPlugin,
    required bool fullScreen,
    bool important = false,
  }) async {
    final androidNotificationDetails = AndroidNotificationDetails(
      id,
      channelName,
      fullScreenIntent: fullScreen,
      actions: actions,
      priority: important ? Priority.max : Priority.defaultPriority,
      importance: important ? Importance.max : Importance.defaultImportance,
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

  Future<void> _openIncomingCallPage(NotificationCallModel notificationContent,
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    // cancel notification
    await flutterLocalNotificationsPlugin.cancel(callNotificationId);

    final callRequestsProcessor = Get.find<CallRequestsProcessor>();

    await callRequestsProcessor.onRequestReceived(
      notificationContent.content!.toJson(),
      notificationContent.messageFrom!,
      null,
    );
  }

  void _showMissedCall(NotificationCallModel data,
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) {
    _showNotification(
      id:NOTIFICATIONS.missedCallChannelKey,
      channelName: NOTIFICATIONS.missedCallChannelName,
      title: 'Missed Call',
      fullScreen: false,
      body: 'Missed call from ${data.messageFrom ?? ''}',
      payload: jsonEncode(data.toJson()),
      actions: [],
      flutterLocalNotificationPlugin: flutterLocalNotificationsPlugin,
    );
  }

  void _showIncomingCallNotification(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    NotificationCallModel data,
  ) {
    _showNotification(
      flutterLocalNotificationPlugin: flutterLocalNotificationsPlugin,
      channelName: NOTIFICATIONS.callsChannelName,
      id: NOTIFICATIONS.callsChannelKey,
      title: 'Heyo',
      body: 'Incoming Call from Heyo',
      fullScreen: true,
      important: true,
      actions: [
        const AndroidNotificationAction('1', 'Accept', showsUserInterface: true),
        const AndroidNotificationAction('2', 'Deny')
      ],
      payload: jsonEncode(data.toJson()),
    );
  }
}
