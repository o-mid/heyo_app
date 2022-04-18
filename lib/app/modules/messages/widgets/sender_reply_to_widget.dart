import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heyo/app/modules/messages/data/models/message_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/fonts.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/generated/assets.gen.dart';

class SenderReplyToWidget extends StatelessWidget {
  final ReplyToModel replyTo;
  const SenderReplyToWidget({Key? key, required this.replyTo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 8.w,
              vertical: 8.h,
            ),
            margin: EdgeInsets.only(bottom: 8.h, right: 32.w, top: 12.h),
            decoration: BoxDecoration(
              border: Border.all(
                color: COLORS.kPinCodeDeactivateColor,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Row(
                  textDirection: TextDirection.ltr,
                  children: [
                    Assets.svg.replyFilled.svg(
                      width: 12.w,
                      height: 12.w,
                    ),
                    CustomSizes.smallSizedBoxWidth,
                    Text(
                      replyTo.repliedToName,
                      style: TEXTSTYLES.kBodyTag.copyWith(
                        color: COLORS.kDarkBlueColor,
                        fontWeight: FONTS.SemiBold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  replyTo.repliedToMessage,
                  textAlign: TextAlign.end,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TEXTSTYLES.kBodyTag.copyWith(
                    color: COLORS.kTextBlueColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        Spacer(),
      ],
    );
  }
}
