import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:heyo/app/modules/shared/data/models/notification_type.dart';
import 'package:heyo/app/modules/shared/data/providers/blockchain/blockchain_provider.dart';
import 'package:heyo/app/modules/shared/data/providers/network/netowrk_request_provider.dart';
import 'package:heyo/app/modules/shared/data/providers/notifications/notification_provider.dart';
import 'package:heyo/app/modules/shared/data/repository/account/account_repository.dart';
import 'package:heyo/app/modules/shared/providers/crypto/storage/libp2p_storage_provider.dart';
import 'package:heyo/app/modules/shared/utils/extensions/dio.extension.dart';

class AppNotificationProvider extends NotificationProvider {
  NetworkRequest networkRequest;
  LibP2PStorageProvider libP2PStorageProvider;
  BlockchainProvider blockchainProvider;
  final AccountRepository accountRepository;

  AppNotificationProvider({
    required this.networkRequest,
    required this.libP2PStorageProvider,
    required this.blockchainProvider,
    required this.accountRepository,
  });

  @override
  Future<bool> pushFCMToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    final privateKey = await libP2PStorageProvider.getPrivateKey();

    if (privateKey == null || fcmToken == null) return false;

    final signature = await blockchainProvider.createFcmRegisterSignature(
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
  Future<bool> sendNotification({
    required String remoteDelegatedCoreId,
    required NotificationType notificationType,
    required String content,
  }) async {
    final userCoreId = await accountRepository.getUserAddress();
    final result = await networkRequest.post(
      path: 'notification-service/notification/send',
      data: {
        'coreId': remoteDelegatedCoreId,
        'notificationType': notificationType.name.toUpperCase(),
        'senderUsername': '',
        'content': content,
        'senderCoreId': userCoreId,
        'title': 'Heyo',
        'body': null,
      },
    );
    return result.isSuccess();
  }
}
