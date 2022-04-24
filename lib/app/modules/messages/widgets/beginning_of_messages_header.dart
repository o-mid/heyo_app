import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:heyo/app/modules/chats/data/models/chat_model.dart';

import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/utils/widgets/curtom_circle_avatar.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';

class BeginningOfMessagesHeader extends StatelessWidget {
  final ChatModel chat;
  const BeginningOfMessagesHeader({
    Key? key,
    required this.chat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Todo: Add group header
    return Container(
      margin: EdgeInsets.all(16.w).copyWith(top: 0, bottom: 16.h),
      padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 24.h),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: COLORS.kPinCodeDeactivateColor,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          CustomCircleAvatar(url: chat.icon, size: 64),
          CustomSizes.mediumSizedBoxHeight,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                chat.name,
                style: TEXTSTYLES.kHeaderLarge.copyWith(color: COLORS.kDarkBlueColor),
              ),
              CustomSizes.smallSizedBoxWidth,
              Container(
                width: 24.w,
                height: 24.w,
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: COLORS.kBlueColor,
                  shape: BoxShape.circle,
                ),
                child: Assets.svg.verified.svg(color: COLORS.kWhiteColor),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          // Todo: show core id
          Text(
            "CB13...586A",
            style: TEXTSTYLES.kBodySmall.copyWith(color: COLORS.kTextBlueColor),
          ),
          CustomSizes.mediumSizedBoxHeight,
          Text(
            LocaleKeys.MessagesPage_endToEndEncryptedMessaging.trParams(
              {"name": chat.name},
            ),
            style: TEXTSTYLES.kBodySmall.copyWith(color: COLORS.kTextBlueColor),
          ),
        ],
      ),
    );
  }
}
