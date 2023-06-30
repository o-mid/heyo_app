import 'package:get/get.dart';
import 'package:heyo/app/modules/notifications/controllers/app_notifications.dart';

import '../../chats/data/providers/chat_history/chat_history_provider.dart';
import '../../chats/data/repos/chat_history/chat_history_repo.dart';
import '../controllers/notifications_controller.dart';

class NotificationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationsController>(
      () => NotificationsController(
        appNotifications: Get.find<AppNotifications>(),
      ),
    );
  }
}
