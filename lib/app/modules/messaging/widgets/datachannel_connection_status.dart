import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/constants/transitions_constant.dart';
import 'package:heyo/generated/locales.g.dart';

import '../../shared/utils/constants/colors.dart';
import '../../shared/widgets/connection_status_body.dart';
import '../controllers/common_messaging_controller.dart';
import '../controllers/messaging_connection_controller.dart';

class DatachannelConnectionStatusWidget extends GetView<CommonMessagingConnectionController> {
  DatachannelConnectionStatusWidget({Key? key}) : super(key: key);
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
      switch (controller.dataChannelStatus.value) {
        case DataChannelConnectivityStatus.connectionLost:
          title = LocaleKeys.DataChannelStatus_ConnectionLost.tr;
          backgroundColor = COLORS.kStatesLightErrorColor;
          titleColor = COLORS.kStatesErrorColor;
          break;

        case DataChannelConnectivityStatus.connecting:
          title = LocaleKeys.DataChannelStatus_connecting.tr;
          backgroundColor = COLORS.kBrightBlueColor;
          titleColor = COLORS.kDarkBlueColor;
          break;

        case DataChannelConnectivityStatus.justConnected:
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
          duration: TRANSITIONS.messagingPage_DatachannelConnectionStatusDurtion,
          transitionBuilder: (child, animation) => SlideTransition(
                position: offsetAnimation.animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: TRANSITIONS.messagingPage_DatachannelConnectionStatusCurve,
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
        controller.dataChannelStatus.value = DataChannelConnectivityStatus
            .values[Random().nextInt(DataChannelConnectivityStatus.values.length)];
      });
    }
  }
}
