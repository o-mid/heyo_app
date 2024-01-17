import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/data/notification_processor.dart';
import 'package:heyo/app/modules/connection/domain/connection_contractor.dart';
import 'package:heyo/app/modules/home/controllers/data_request_dialog.dart';
import 'package:heyo/app/modules/home/data/repository/home_repository.dart';
import 'package:heyo/app/modules/p2p_node/p2p_state.dart';
import 'package:heyo/main.dart';

class HomeController extends GetxController {
  final tabIndex = 0.obs;
  final P2PState p2pState;
  ConnectionContractor connectionContractor;
  HomeRepository homeRepository;
  FlutterLocalNotificationsPlugin flutterLocalNotification;

  HomeController({
    required this.flutterLocalNotification,
    required this.p2pState,
    required this.connectionContractor,
    required this.homeRepository,
  });

  @override
  void onInit() {
    homeRepository.sendFCMToken();
    connectionContractor.start();
    assessPendingNotifications();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  void changeTabIndex(int index) {
    if (index == dataRequestTabIndex) {
      dataRequestDialog(Get.context!);
    } else {
      tabIndex.value = index;
    }
  }

  Future<void> assessPendingNotifications() async {
    final pendingNotification =
        await flutterLocalNotification.getNotificationAppLaunchDetails();

    final payload = pendingNotification?.notificationResponse?.payload;

    final launchedFromNotification =
        pendingNotification?.didNotificationLaunchApp ?? false;

    if (payload != null && launchedFromNotification) {
      NotificationProcessor.process(
        null,
        payload,
        flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
        isBackgroundNotification: false,
      );
    }
  }
}

const int dataRequestTabIndex = 2;
