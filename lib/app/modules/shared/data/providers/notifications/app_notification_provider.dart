import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:heyo/app/modules/shared/data/providers/network/netowrk_request_provider.dart';
import 'package:heyo/app/modules/shared/data/providers/notifications/notification_provider.dart';
import 'package:heyo/app/modules/shared/data/repository/crypto_account/account_repository.dart';
import 'package:heyo/app/modules/shared/providers/crypto/storage/libp2p_storage_provider.dart';
import 'package:heyo/app/modules/shared/utils/extensions/dio.extension.dart';

class AppNotificationProvider extends NotificationProvider {
  NetworkRequest networkRequest;
  LibP2PStorageProvider libP2PStorageProvider;

  AppNotificationProvider({
    required this.networkRequest,
    required this.libP2PStorageProvider,
  });

  @override
  Future<bool> pushFCMToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    final signature = await libP2PStorageProvider.getSignature();
    if (signature == null || fcmToken == null) return false;
    final response = await networkRequest.post(path: 'user/register', data: {
      'fcmToken': fcmToken,
      'signature': signature,
    });
    return response.isSuccess();
  }
}
