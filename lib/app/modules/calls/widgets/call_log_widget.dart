import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/data/models/call_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/extensions/datetime.extension.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/widgets/curtom_circle_avatar.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';
import 'package:intl/intl.dart';

class CallLogWidget extends StatelessWidget {
  final CallModel call;
  const CallLogWidget({
    super.key,
    required this.call,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomCircleAvatar(url: call.user.icon, size: 40),
        CustomSizes.mediumSizedBoxWidth,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  call.user.name,
                  style: TEXTSTYLES.kChatName.copyWith(
                    color: COLORS.kDarkBlueColor,
                  ),
                ),
                SizedBox(width: 8.w),
                if (call.user.isVerified)
                  Assets.svg.verifiedWithBluePadding.svg(
                    width: 16.w,
                    height: 16.w,
                  ),
              ],
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                _buildCallStatus(),
                SizedBox(width: 10.w),
                _buildCallDate(),
              ],
            ),
          ],
        ),
        const Spacer(),
        _buildCallTypeIcon(),
      ],
    );
  }

  Widget _buildCallStatus() {
    switch (call.status) {
      case CallStatus.outgoingAnswered:
      case CallStatus.outgoingCanceled:
      case CallStatus.outgoingDeclined:
      case CallStatus.outgoingNotAnswered:
        return Assets.svg.callOutgoing.svg();

      case CallStatus.incomingAnswered:
        return Assets.svg.callIncoming.svg(color: COLORS.kStatesSuccessColor);
      case CallStatus.incomingMissed:
        return Assets.svg.callIncoming.svg(color: COLORS.kStatesErrorColor);
    }
  }

  Widget _buildCallDate() {
    var textColor = COLORS.kTextBlueColor;
    if (call.status == CallStatus.incomingMissed) {
      textColor = COLORS.kStatesErrorColor;
    }

    String callTime = DateFormat('d MMMM, hh:mm').format(call.date);
    if (DateTime.now().isSameDate(call.date)) {
      callTime = _formatDuration();
    }

    return Text(
      callTime,
      style: TEXTSTYLES.kBodySmall.copyWith(color: textColor),
    );
  }

  Widget _buildCallTypeIcon() {
    return Container(
      width: 40.w,
      height: 40.w,
      padding: EdgeInsets.all(10.w),
      decoration: const BoxDecoration(
        color: COLORS.kBrightBlueColor,
        shape: BoxShape.circle,
      ),
      child: call.type == CallType.audio
          ? Assets.svg.audioCallIcon.svg(color: COLORS.kDarkBlueColor)
          : Assets.svg.videoCallIcon.svg(color: COLORS.kDarkBlueColor),
    );
  }

  String _formatDuration() {
    final difference = DateTime.now().difference(call.date);

    String duration = "";

    /// if hour and minute are both greater than zero separate them with a space
    final joiner = difference.inHours > 0 && difference.inMinutes > 0 ? " " : "";

    if (difference.inHours > 0) {
      duration += LocaleKeys.HomePage_Calls_hour.trPluralParams(
        LocaleKeys.HomePage_Calls_hours,
        difference.inHours,
        {"count": difference.inHours.toString()},
      );
      duration += joiner;
    }

    if (difference.inMinutes > 0) {
      duration += LocaleKeys.HomePage_Calls_minute.trPluralParams(
        LocaleKeys.HomePage_Calls_minutes,
        difference.inMinutes,
        {"count": difference.inMinutes.toString()},
      );
    }

    return LocaleKeys.HomePage_Calls_durationAgo.trParams({
      "duration": duration,
    });
  }
}
