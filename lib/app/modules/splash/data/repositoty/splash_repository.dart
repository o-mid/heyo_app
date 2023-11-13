import 'package:flutter/foundation.dart';
import 'package:heyo/app/modules/shared/data/providers/notifications/notification_provider.dart';
import 'package:heyo/app/modules/splash/data/repositoty/splash_abstract_repository.dart';

class SplashRepository extends SplashAbstractRepository {
  NotificationProvider notificationProvider;

  SplashRepository({
    required this.notificationProvider,
  });

  @override
  Future<bool> sendFCMToken() async {
    return notificationProvider.pushFCMToken();
  }
}
