import 'package:heyo/app/modules/home/data/repository/home_repository.dart';
import 'package:heyo/app/modules/shared/data/providers/notifications/notification_provider.dart';

class HomeRepositoryImpl extends HomeRepository {

  HomeRepositoryImpl({required this.notificationProvider});

  NotificationProvider notificationProvider;

  @override
  Future<bool> sendFCMToken() async {
    return notificationProvider.pushFCMToken();
  }
}
