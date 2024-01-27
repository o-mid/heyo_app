import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/call_history/views/models/call_history_view_model/call_history_view_model.dart';
import 'package:heyo/app/modules/calls/shared/data/models/call_history_model/call_history_model.dart';
import 'package:heyo/app/modules/calls/shared/utils/call_utils.dart';
import 'package:heyo/app/modules/calls/shared/widgets/call_status_icon_and_date.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/generated/locales.g.dart';

class HistoryCallLogWidget extends StatelessWidget {
  const HistoryCallLogWidget({required this.call, super.key});

  final CallHistoryViewModel call;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              call.type,
              style: TEXTSTYLES.kChatName.copyWith(
                color: COLORS.kDarkBlueColor,
              ),
            ),
            const Spacer(),
            Text(
              call.status,
              style: TEXTSTYLES.kBodySmall.copyWith(
                color: COLORS.kTextBlueColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Row(
          children: [
            CallStatusIconAndDate(call: call),
            //const Spacer(),
            //if (call.dataUsageMB > 0)
            //  Text(
            //    "${call.dataUsageMB} MB",
            //    style: TEXTSTYLES.kBodySmall
            //        .copyWith(color: COLORS.kTextBlueColor),
            //  ),
          ],
        ),
      ],
    );
  }
}
