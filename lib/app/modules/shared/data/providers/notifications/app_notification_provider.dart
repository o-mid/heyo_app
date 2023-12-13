import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:heyo/app/modules/shared/data/models/fcm_register_model.dart';
import 'package:heyo/app/modules/shared/data/models/notification_type.dart';
import 'package:heyo/app/modules/shared/data/providers/network/netowrk_request_provider.dart';
import 'package:heyo/app/modules/shared/data/providers/notifications/notification_provider.dart';
import 'package:heyo/app/modules/shared/data/providers/registry/registery_provider.dart';
import 'package:heyo/app/modules/shared/data/repository/crypto_account/account_repository.dart';
import 'package:heyo/app/modules/shared/providers/crypto/storage/libp2p_storage_provider.dart';
import 'package:heyo/app/modules/shared/utils/extensions/dio.extension.dart';

class AppNotificationProvider extends NotificationProvider {
  NetworkRequest networkRequest;
  LibP2PStorageProvider libP2PStorageProvider;
  RegistryProvider registryProvider;

  AppNotificationProvider({
    required this.networkRequest,
    required this.libP2PStorageProvider,
    required this.registryProvider,
  });

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

    final response = await networkRequest
        .post(path: 'notification-service/user/register', data: {
      'fcmToken': fcmToken,
      'signature': signature,
    });
    
    return response.isSuccess();
  }

  @override
  Future<bool> sendNotification({
    required String remoteDelegatedCoreId,
    required NotificationType notificationType,
  }) async {
    final result = await networkRequest
        .post(path: 'notification-service/notification/send', data: {
      'coreId': remoteDelegatedCoreId,
      'notificationType': notificationType.name.toUpperCase(),
      'senderUsername': 'Johnathan Baby',
    });
    return result.isSuccess();
  }
}
