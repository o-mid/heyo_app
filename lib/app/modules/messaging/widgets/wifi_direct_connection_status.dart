import 'dart:math';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:heyo/app/modules/messaging/controllers/wifi_direct_connection_controller.dart';

import 'package:heyo/generated/locales.g.dart';

import '../../shared/utils/constants/colors.dart';
import '../../shared/widgets/connection_status_body.dart';

class WifiDirectConnectionStatusWidget extends GetView<WifiDirectConnectionController> {
  WifiDirectConnectionStatusWidget({Key? key}) : super(key: key);
  final offsetAnimation = Tween<Offset>(
    begin: const Offset(0, -1),
    end: const Offset(0, 0),
  );
  @override
  Widget build(BuildContext context) {
    // To get a overview of the status change in the Ui uncomment the following line

    // randomStatus(
    //   frequency: 10,
    //   delayInSeconds: 4,
    // );
    return Obx(() {
      Color backgroundColor;
      String title;
      Color titleColor;
      switch (controller.wifiDirectStatus.value) {
        // Todo : Change the names of the status to match the Wifi Direct new ones in the enum if needed
        case WifiDirectConnectivityStatus.connectionLost:
          title = LocaleKeys.DataChannelStatus_ConnectionLost.tr;
          backgroundColor = COLORS.kStatesLightErrorColor;
          titleColor = COLORS.kStatesErrorColor;
          break;

        case WifiDirectConnectivityStatus.connecting:
          title = LocaleKeys.DataChannelStatus_connecting.tr;
          backgroundColor = COLORS.kBrightBlueColor;
          titleColor = COLORS.kDarkBlueColor;
          break;

        case WifiDirectConnectivityStatus.justConnected:
          title = LocaleKeys.DataChannelStatus_connected.tr;
          backgroundColor = COLORS.kGreenLighterColor;
          titleColor = COLORS.kStatesSuccessColor;
          break;
        default:
          title = "";
          backgroundColor = Colors.transparent;
          titleColor = Colors.transparent;
          break;
      }

      return AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          transitionBuilder: (child, animation) => SlideTransition(
                position: offsetAnimation.animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeInOut),
                ),
                child: child,
              ),
          child: title.isNotEmpty
              ? ConnectionStatusBody(
                  title: title,
                  backgroundColor: backgroundColor,
                  titleColor: titleColor,
                )
              : const SizedBox(
                  height: 0,
                  width: 0,
                ));
    });
  }

// change the Status randomly base on the frequency and delay given for testing
  void randomStatus({
    required int frequency,
    required int delayInSeconds,
  }) async {
    for (var i = 0; i < frequency; i++) {
      await Future.delayed(Duration(seconds: delayInSeconds), () {
        controller.wifiDirectStatus.value = WifiDirectConnectivityStatus
            .values[Random().nextInt(WifiDirectConnectivityStatus.values.length)];
      });
    }
  }
}
