import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heyo/app/modules/messages/data/models/messages/message_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/fonts.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/generated/assets.gen.dart';

class RecipientReplyTo extends StatelessWidget {
  final MessageModel message;
  const RecipientReplyTo({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final replyTo = message.replyTo;
    if (replyTo == null) {
      return SizedBox.shrink();
    }

    return Stack(
      children: [
        Positioned(
          bottom: 2.w,
          left: 19.w,
          child: Container(
            width: 8.w,
            height: 40.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(4.w)),
              border: Border.all(color: COLORS.kTextSoftBlueColor, width: 1.w),
            ),
          ),
        ),

        // This hides the right and bottom border of the top container
        Positioned(
          // w is used for bottom because border width is based on w and should be offset according to that
          bottom: 1.w,
          left: 20.w,
          child: Container(
            width: 8.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: message.isSelected
                  ? COLORS.kGreenLighterColor
                  : COLORS.kAppBackground,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(4.w)),
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                  vertical: 8.h,
                ),
                margin: EdgeInsets.only(bottom: 8.h, left: 32.w, top: 4.h),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: COLORS.kPinCodeDeactivateColor,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Row(
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
                      maxLines: 2,
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
        ),
      ],
    );
  }
}
