import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:heyo/app/modules/chats/data/models/chat_model.dart';
import 'package:heyo/app/modules/messages/controllers/messages_controller.dart';

import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/widgets/curtom_circle_avatar.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';

import '../../../new_chat/data/models/user_model.dart';

class BeginningOfMessagesHeaderWidget extends StatelessWidget {
  final String iconUrl;
  final String userName;
  const BeginningOfMessagesHeaderWidget({
    Key? key,
    required this.iconUrl,
    required this.userName,
    //required this.user,
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
          CustomCircleAvatar(url: iconUrl, size: 64),
          CustomSizes.mediumSizedBoxHeight,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                userName,
                style: TEXTSTYLES.kHeaderLarge.copyWith(color: COLORS.kDarkBlueColor),
              ),
              CustomSizes.smallSizedBoxWidth,
              Container(
                width: 24.w,
                height: 24.w,
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                decoration: const BoxDecoration(
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
              {"name": userName},
            ),
            style: TEXTSTYLES.kBodySmall.copyWith(color: COLORS.kTextBlueColor),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
