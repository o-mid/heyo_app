import 'package:heyo/app/modules/notifications/controllers/app_notifications.dart';
import 'package:heyo/app/modules/notifications/controllers/notifications_controller.dart';
import 'package:heyo/app/modules/shared/data/providers/notifications/app_notification_provider.dart';
import 'package:heyo/app/modules/shared/data/providers/notifications/notification_provider.dart';
import 'package:heyo/core/di/injector_provider.dart';
import 'package:heyo/core/di/priority_injector_interface.dart';

class NotificationInjector with NormalPriorityInjector {
  @override
  void executeNormalPriorityInjector() {
    inject
      ..registerSingleton(
        AppNotifications(),
        //permanent: true,
      )
      ..registerSingleton(
        NotificationsController(
          appNotifications: inject.get(),
          chatHistoryRepo: inject.get(),
        ),
      )
      ..registerSingleton<NotificationProvider>(
        AppNotificationProvider(
          networkRequest: inject.get(),
          libP2PStorageProvider: inject.get(),
          blockchainProvider: inject.get(),
          accountRepository: inject.get(),
        ),
      );
  }
}
