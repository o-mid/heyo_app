import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/controllers/connection_controller.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/generated/locales.g.dart';

import '../utils/constants/colors.dart';

class ConnectionStatusWidget extends GetView<ConnectionController> {
  const ConnectionStatusWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      switch (controller.currentConnectionStatus.value) {
        case ConnectionStatus.connectionLost:
          return _StatusBody(
            title: LocaleKeys.ConnectionStatus_waiting.tr,
            backgroundColor: COLORS.kStatesLightErrorColor,
            titleColor: COLORS.kStatesErrorColor,
          );

        case ConnectionStatus.updating:
          return _StatusBody(
            title: LocaleKeys.ConnectionStatus_updating.tr,
            backgroundColor: COLORS.kBrightBlueColor,
            titleColor: COLORS.kDarkBlueColor,
          );

        case ConnectionStatus.justConnected:
          return _StatusBody(
            title: LocaleKeys.ConnectionStatus_backOnline.tr,
            backgroundColor: COLORS.kGreenLighterColor,
            titleColor: COLORS.kStatesSuccessColor,
          );
        default:
          return const SizedBox(height: 0, width: 0);
      }
    });
  }
}

class _StatusBody extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final Color titleColor;
  const _StatusBody(
      {Key? key, required this.title, required this.backgroundColor, required this.titleColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: Container(
        color: backgroundColor,
        child: Center(
          child: Text(
            title,
            style: TEXTSTYLES.kBodySmall.copyWith(
              color: titleColor,
            ),
          ),
        ),
      ),
    );
  }
}
