import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heyo/app/modules/messages/data/models/messages/message_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/generated/assets.gen.dart';

class MessageHeaderWidget extends StatelessWidget {
  final MessageModel message;
  const MessageHeaderWidget({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: message.isFromMe ? TextDirection.rtl : TextDirection.ltr,
      children: [
        CustomSizes.mediumSizedBoxWidth,
        Text(
          "${message.timestamp.hour.toString().padLeft(2, '0')}:${message.timestamp.minute.toString().padLeft(2, '0')}",
          style: TEXTSTYLES.kBodyTag.copyWith(
            color: COLORS.kTextBlueColor,
            fontSize: 10.sp,
          ),
        ),
        SizedBox(width: 4.w),
        if (message.isFromMe && message.status == MESSAGE_STATUS.SENDING)
          Assets.svg.clock.svg(
            width: 10.w,
            height: 10.w,
          ),
        if (message.isFromMe && message.status == MESSAGE_STATUS.SENT)
          Assets.svg.singleTickIcon.svg(
            width: 8.w,
            height: 8.w,
          ),
        if (message.isFromMe && message.status == MESSAGE_STATUS.READ)
          Assets.svg.doubleTickIcon.svg(
            width: 12.w,
            height: 8.w,
          ),
      ],
    );
  }
}
