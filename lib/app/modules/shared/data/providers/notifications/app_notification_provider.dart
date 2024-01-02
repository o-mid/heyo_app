import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:heyo/app/modules/shared/data/models/notification_type.dart';
import 'package:heyo/app/modules/shared/data/providers/network/netowrk_request_provider.dart';
import 'package:heyo/app/modules/shared/data/providers/notifications/notification_provider.dart';
import 'package:heyo/app/modules/shared/data/providers/registry/registery_provider.dart';
import 'package:heyo/app/modules/shared/providers/crypto/storage/libp2p_storage_provider.dart';
import 'package:heyo/app/modules/shared/utils/extensions/dio.extension.dart';

class AppNotificationProvider extends NotificationProvider {
  NetworkRequest networkRequest;
  LibP2PStorageProvider libP2PStorageProvider;
  RegistryProvider registryProvider;

  final StreamController<String> _streamController =
      StreamController<String>.broadcast();

  AppNotificationProvider({
    required this.networkRequest,
    required this.libP2PStorageProvider,
    required this.registryProvider,
  }) {
    _listen();
  }

  @override
  Future<bool> pushFCMToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    final privateKey = await libP2PStorageProvider.getPrivateKey();

    if (privateKey == null || fcmToken == null) return false;

    final signature = await registryProvider.createFcmRegisterSignature(
      fcmToken: fcmToken,
      privateKey: privateKey,
    );

    if (signature == null) return false;
    print("$fcmToken");
    print("$signature");

    final corePassSignature = await libP2PStorageProvider.getSignature();
    final coreId = await libP2PStorageProvider.getCorePassCoreId();
    print("$coreId");
    print("$corePassSignature");

    final response = await networkRequest.post(
      path: 'notification-service/user/register',
      data: {
        'fcmToken': "$fcmToken",
        'signature': "$signature",
        'coreId': "$coreId",
        'coreSignature': "$corePassSignature",
      },
    );

    return response.isSuccess();
  }

  @override
  Future<bool> sendNotification(
      {required String remoteDelegatedCoreId,
      required NotificationType notificationType,
      required String content}) async {
    final result = await networkRequest.post(
      path: 'notification-service/notification/send',
      data: {
        'coreId': remoteDelegatedCoreId,
        'notificationType': notificationType.name.toUpperCase(),
        'senderUsername': '',
        'content': content
      },
    );
    return result.isSuccess();
  }

  void _listen() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('-----------------------------------------------------');
      print("${message.from}");
      print("${message.contentAvailable}");
      print("${message.data}");
      final diff = DateTime.now().millisecondsSinceEpoch -
          message.sentTime!.millisecondsSinceEpoch;
      print("diff ${diff}");

      print('Handling a foreground message: ${message.messageId}');
      print('Message data: ${message.data}');
      print('Message notification: ${message.notification?.title}');
      print('Message notification: ${message.notification?.body}');
      if (diff < 15 * 1000 && message.notification?.body != null) {
        print("Call accepted");
        _streamController.add(message.notification!.body!);
      } else {
        print("Call is not accepted");
      }
      print('-----------------------------------------------------');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print("onMessageOpened ${event.data}");
    });
    print('-FirebaseMessaging');
  }

  @override
  Stream<String> getNotificationStream() {
    return _streamController.stream.asBroadcastStream();
  }
}
