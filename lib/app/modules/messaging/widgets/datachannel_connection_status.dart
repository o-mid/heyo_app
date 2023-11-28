import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/messaging/unified_messaging_controller.dart';

import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/constants/transitions_constant.dart';
import 'package:heyo/generated/locales.g.dart';

import '../../shared/utils/constants/colors.dart';
import '../../shared/widgets/connection_status_body.dart';
import '../connection/connection_repo.dart';

/*
class DatachannelConnectionStatusWidget extends GetView<UnifiedConnectionController> {
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
    Rx<ConnectivityStatus> dataChannelStatus = controller.connectionRepo.connectivityStatus;
    return Obx(() {
      Color backgroundColor;
      String title;
      Color titleColor;
      switch (dataChannelStatus.value) {
        case ConnectivityStatus.connectionLost:
          title = LocaleKeys.DataChannelStatus_ConnectionLost.tr;
          backgroundColor = COLORS.kStatesLightErrorColor;
          titleColor = COLORS.kStatesErrorColor;
          break;

        case ConnectivityStatus.connecting:
          title = LocaleKeys.DataChannelStatus_connecting.tr;
          backgroundColor = COLORS.kBrightBlueColor;
          titleColor = COLORS.kDarkBlueColor;
          break;

        case ConnectivityStatus.justConnected:
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
}
*/
