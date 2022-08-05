import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/shared/data/models/call_model.dart';
import 'package:heyo/app/modules/calls/shared/widgets/call_status_icon_and_date.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/generated/locales.g.dart';

class HistoryCallLogWidget extends StatelessWidget {
  final CallModel call;
  const HistoryCallLogWidget({
    super.key,
    required this.call,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              _callTitle(),
              style: TEXTSTYLES.kChatName.copyWith(color: COLORS.kDarkBlueColor),
            ),
            const Spacer(),
            Text(
              _callStatus(),
              style: TEXTSTYLES.kBodySmall.copyWith(color: COLORS.kTextBlueColor),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Row(
          children: [
            CallStatusIconAndDate(call: call),
            const Spacer(),
            if (call.dataUsageMB > 0)
              Text(
                "${call.dataUsageMB} MB",
                style: TEXTSTYLES.kBodySmall.copyWith(color: COLORS.kTextBlueColor),
              ),
          ],
        ),
      ],
    );
  }

  String _callTitle() {
    switch (call.status) {
      case CallStatus.incomingMissed:
        return LocaleKeys.CallHistory_missedCall.tr;
      case CallStatus.incomingAnswered:
      case CallStatus.incomingDeclined:
        return LocaleKeys.CallHistory_incoming.tr;
      case CallStatus.outgoingAnswered:
      case CallStatus.outgoingCanceled:
      case CallStatus.outgoingDeclined:
      case CallStatus.outgoingNotAnswered:
        return LocaleKeys.CallHistory_outgoing.tr;
    }
  }

  String _callStatus() {
    switch (call.status) {
      case CallStatus.outgoingDeclined:
        return LocaleKeys.CallHistory_callDeclined.tr;
      case CallStatus.outgoingNotAnswered:
        return LocaleKeys.CallHistory_notAnswered.tr;
      case CallStatus.outgoingCanceled:
        return LocaleKeys.CallHistory_callCanceled.tr;

      case CallStatus.incomingAnswered:
      case CallStatus.outgoingAnswered:
        return "${call.duration.inMinutes}:${(call.duration.inSeconds % 60).toString().padLeft(2, "0")}";

      default:
        return "";
    }
  }
}
