import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/generated/locales.g.dart';

import '../../shared/utils/constants/colors.dart';
import '../controllers/messaging_connection_controller.dart';

class DatachannelConnectionStatusWidget extends GetView<MessagingConnectionController> {
  const DatachannelConnectionStatusWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      switch (controller.dataChannelStatus.value) {
        case DataChannelConnectivityStatus.connectionLost:
          return _StatusBody(
            title: LocaleKeys.DataChannelStatus_ConnectionLost.tr,
            backgroundColor: COLORS.kStatesLightErrorColor,
            titleColor: COLORS.kStatesErrorColor,
          );

        case DataChannelConnectivityStatus.connecting:
          return _StatusBody(
            title: LocaleKeys.DataChannelStatus_connecting.tr,
            backgroundColor: COLORS.kBrightBlueColor,
            titleColor: COLORS.kDarkBlueColor,
          );

        case DataChannelConnectivityStatus.justConnected:
          return _StatusBody(
            title: LocaleKeys.DataChannelStatus_connected.tr,
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
