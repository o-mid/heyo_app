import 'package:heyo/app/modules/shared/data/models/notification_type.dart';

abstract class NotificationProvider {

  Future<bool> pushFCMToken();

  Future<bool> sendNotification({
    required String remoteDelegatedCoreId,
    required NotificationType notificationType,
    required String content,
  });
}
