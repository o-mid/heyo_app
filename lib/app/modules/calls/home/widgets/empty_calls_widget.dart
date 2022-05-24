import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';

class EmptyCallsWidget extends StatelessWidget {
  const EmptyCallsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 72.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 174.w,
            width: 174.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  const Color(0xffE9FBF8),
                  const Color(0xffE9FBF8).withOpacity(0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Assets.png.callsEmptyState.image(),
          ),
          SizedBox(height: 72.h),
          Text(
            LocaleKeys.HomePage_Calls_emptyState_title.tr,
            style: TEXTSTYLES.kHeaderLarge.copyWith(color: COLORS.kDarkBlueColor),
          ),
          CustomSizes.smallSizedBoxHeight,
          Text(
            LocaleKeys.HomePage_Calls_emptyState_subtitle.tr,
            style: TEXTSTYLES.kBodySmall.copyWith(
              color: COLORS.kTextBlueColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
