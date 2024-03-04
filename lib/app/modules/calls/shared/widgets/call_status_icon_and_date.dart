import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/shared/data/models/call_history_model/call_history_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/extensions/datetime.extension.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';
import 'package:heyo/modules/call/presentation/call_history/call_history_view_model/call_history_view_model.dart';
import 'package:intl/intl.dart';

class CallStatusIconAndDate extends StatelessWidget {
  const CallStatusIconAndDate({required this.call, super.key});

  final CallHistoryViewModel call;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _callStatusIcon(),
        SizedBox(width: 4.w),
        _buildCallDate(),
      ],
    );
  }

  Widget _callStatusIcon() {
    switch (call.status) {
      case CallStatus.outgoingAnswered:
      case CallStatus.outgoingCanceled:
      case CallStatus.outgoingDeclined:
      case CallStatus.outgoingNotAnswered:
        return Assets.svg.outgoingCall2.svg(color: COLORS.kTextSoftBlueColor);

      case CallStatus.incomingAnswered:
      case CallStatus.incomingDeclined:
        return Assets.svg.incomingCall.svg(color: COLORS.kTextSoftBlueColor);
      case CallStatus.incomingMissed:
        return Assets.svg.missedCall.svg(color: COLORS.kStatesErrorColor);
      default:
        return Assets.svg.missedCall.svg(color: COLORS.kStatesErrorColor);
    }
  }

  Widget _buildCallDate() {
    var textColor = COLORS.kTextSoftBlueColor;
    if (call.status == CallStatus.incomingMissed) {
      textColor = COLORS.kStatesErrorColor;
    }

    String callTime = DateFormat('d MMMM, hh:mm').format(call.startDate);
    if (DateTime.now().isSameDate(call.startDate)) {
      callTime = _formatDuration();
    }

    return Text(
      callTime,
      style: TEXTSTYLES.kBodySmall.copyWith(color: textColor),
    );
  }

  String _formatDuration() {
    final difference = DateTime.now().difference(call.startDate);

    var duration = '';
    final hours = difference.inMinutes ~/ 60;
    final minutes = difference.inMinutes % 60;

    /// if hour and minute are both greater than zero separate them with a space
    final joiner = hours > 0 && difference.inMinutes > 0 ? ' ' : '';

    if (hours > 0) {
      duration += LocaleKeys.HomePage_Calls_hour.trPluralParams(
        LocaleKeys.HomePage_Calls_hours,
        hours,
        {'count': hours.toString()},
      );
      duration += joiner;
    }

    if (minutes > 0) {
      duration += LocaleKeys.HomePage_Calls_minute.trPluralParams(
        LocaleKeys.HomePage_Calls_minutes,
        minutes,
        {'count': minutes.toString()},
      );
    }

    if (minutes == 0 && hours == 0) {
      duration += LocaleKeys.HomePage_Calls_minute.trPluralParams(
        LocaleKeys.HomePage_Calls_minutes,
        minutes,
        {'count': minutes.toString()},
      );
    }

    return LocaleKeys.HomePage_Calls_durationAgo.trParams({
      'duration': duration,
    });
  }
}
