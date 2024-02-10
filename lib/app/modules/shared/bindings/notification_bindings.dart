import 'package:get/get.dart';
import 'package:heyo/app/modules/notifications/controllers/app_notifications.dart';
import 'package:heyo/app/modules/notifications/controllers/notifications_controller.dart';
import 'package:heyo/app/modules/shared/bindings/priority_bindings_interface.dart';
import 'package:heyo/app/modules/shared/data/providers/notifications/app_notification_provider.dart';
import 'package:heyo/app/modules/shared/data/providers/notifications/notification_provider.dart';

class NotificationBindings with NormalPriorityBindings {
  @override
  void executeNormalPriorityBindings() {
    Get
      ..put(AppNotifications(), permanent: true)
      ..put(
        NotificationsController(
          appNotifications: Get.find(),
          chatHistoryRepo: Get.find(),
        ),
      )
      ..put<NotificationProvider>(
        AppNotificationProvider(
          networkRequest: Get.find(),
          libP2PStorageProvider: Get.find(),
          blockchainProvider: Get.find(),
          accountRepository: Get.find(),
        ),
      );
  }
}
