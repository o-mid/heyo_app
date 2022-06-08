import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/data/models/messages/call_message_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/fonts.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/widgets/custom_button.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';

class CallMessageWidget extends StatelessWidget {
  final CallMessageModel message;
  const CallMessageWidget({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        border: Border.all(color: COLORS.kPinCodeDeactivateColor),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: const BoxDecoration(
                  color: COLORS.kTextSoftBlueColor,
                  shape: BoxShape.circle,
                ),
                child: message.callType == CallMessageType.video
                    ? Assets.svg.videoCallIcon.svg()
                    : Assets.svg.audioCallIcon.svg(),
              ),
              CustomSizes.smallSizedBoxWidth,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.MessagesPage_callMessageTitle.trParams(
                          {"user": message.senderName}),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TEXTSTYLES.kChatText.copyWith(
                        fontWeight: FONTS.SemiBold,
                        color: COLORS.kDarkBlueColor,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      message.callStatus == CallMessageStatus.declined
                          ? LocaleKeys.MessagesPage_callMessageSubtitleDeclined.tr
                          : LocaleKeys.MessagesPage_callMessageSubtitleMissed.tr,
                      style: TEXTSTYLES.kChatText.copyWith(color: COLORS.kTextBlueColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
          CustomSizes.smallSizedBoxHeight,
          CustomButton(
            title: LocaleKeys.MessagesPage_callMessageActionButton.tr,
            backgroundColor: COLORS.kGreenLighterColor,
            textStyle: TEXTSTYLES.kLinkBig.copyWith(color: COLORS.kGreenMainColor),
            onTap: () {}, // Todo
          ),
        ],
      ),
    );
  }
}
