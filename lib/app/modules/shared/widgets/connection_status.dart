import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/controllers/connection_controller.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/generated/locales.g.dart';

import '../utils/constants/colors.dart';
import '../utils/constants/transitions_constant.dart';
import 'connection_status_body.dart';

class ConnectionStatusWidget extends GetView<ConnectionController> {
  ConnectionStatusWidget({Key? key}) : super(key: key);
  final offsetAnimation = Tween<Offset>(
    begin: const Offset(0, -1),
    end: const Offset(0, 0),
  );
  @override
  Widget build(BuildContext context) {
    // randomStatus(
    //   frequency: 10,
    //   delayInSeconds: 4,
    // );

    return Obx(() {
      Color backgroundColor;
      String title;
      Color titleColor;
      switch (controller.currentConnectionStatus.value) {
        case ConnectionStatus.connectionLost:
          title = LocaleKeys.ConnectionStatus_waiting.tr;
          backgroundColor = COLORS.kStatesLightErrorColor;
          titleColor = COLORS.kStatesErrorColor;
          break;

        case ConnectionStatus.updating:
          title = LocaleKeys.ConnectionStatus_updating.tr;
          backgroundColor = COLORS.kBrightBlueColor;
          titleColor = COLORS.kDarkBlueColor;
          break;

        case ConnectionStatus.justConnected:
          title = LocaleKeys.ConnectionStatus_backOnline.tr;
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
          duration: TRANSITIONS.connectionStatus_StatusSwitcherDurtion,
          transitionBuilder: (child, animation) => SlideTransition(
                position: offsetAnimation.animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: TRANSITIONS.connectionStatus_StatusCurve,
                  ),
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

  // change the dataChannel Status randomly base on the frequency and delay given for testing
  void randomStatus({
    required int frequency,
    required int delayInSeconds,
  }) async {
    for (var i = 0; i < frequency; i++) {
      await Future.delayed(Duration(seconds: delayInSeconds), () {
        controller.currentConnectionStatus.value =
            ConnectionStatus.values[Random().nextInt(ConnectionStatus.values.length)];
      });
    }
  }
}
