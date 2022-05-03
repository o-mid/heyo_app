import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/data/models/reply_to_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/fonts.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';

class ReplyingToWidget extends StatelessWidget {
  final VoidCallback clearReplyTo;
  final ReplyToModel replyingTo;
  const ReplyingToWidget({
    Key? key,
    required this.clearReplyTo,
    required this.replyingTo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: COLORS.kComposeMessageBackgroundColor,
        border: Border(
          top: BorderSide(
            width: 1,
            color: COLORS.kComposeMessageBorderColor,
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
      child: Row(
        children: [
          GestureDetector(
            onTap: clearReplyTo,
            child: Assets.svg.replyOutlined.svg(
              width: 19.w,
              height: 17.w,
              color: COLORS.kDarkBlueColor,
            ),
          ),
          CustomSizes.mediumSizedBoxWidth,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.MessagesPage_replyingTo.trParams({
                    "name": replyingTo.repliedToName,
                  }),
                  style: TEXTSTYLES.kChatText.copyWith(
                    color: COLORS.kDarkBlueColor,
                    fontWeight: FONTS.SemiBold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  replyingTo.repliedToMessage,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TEXTSTYLES.kChatText.copyWith(color: COLORS.kTextBlueColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
