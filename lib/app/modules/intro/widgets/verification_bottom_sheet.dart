import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/buttons/custom_button.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';

class VerificationBottomSheet extends StatelessWidget {
  final Function? onTap;
  const VerificationBottomSheet({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 0.75.sh,
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          children: [
            //close Button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () => Get.back(),
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 16, 16, 0),
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: COLORS.kBlueLightColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    child: const Icon(Icons.close),
                  ),
                ),
              ],
            ),
            // Heyo and CorePass logos
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Assets.png.heyoLogoCircle.image(width: 48, height: 48),
                CustomSizes.mediumSizedBoxWidth,
                Assets.svg.twoArrowIcon.svg(width: 20, height: 20),
                CustomSizes.mediumSizedBoxWidth,
                Assets.png.corePassLogoCircle.image(width: 48, height: 48),
              ],
            ),
            // Verification title
            CustomSizes.largeSizedBoxHeight,
            Text(
              LocaleKeys.registration_WelcomePage_bottomSheet_title.tr,
              style: TEXTSTYLES.kHeaderLarge.copyWith(),
            ),
            CustomSizes.smallSizedBoxHeight,
            //Secure text and icon
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Assets.svg.lockIcon.svg(),
                CustomSizes.smallSizedBoxWidth,
                Text(
                  LocaleKeys.registration_WelcomePage_bottomSheet_subtitle.tr,
                  style: TEXTSTYLES.kBodySmall.copyWith(
                    color: COLORS.kTextBlueColor,
                  ),
                ),
              ],
            ),
            CustomSizes.semiExtraLargeSizedBoxHeight,
            const Divider(color: COLORS.kTextBlueColor),
            CustomSizes.semiExtraLargeSizedBoxHeight,
            Text(
              LocaleKeys.registration_WelcomePage_bottomSheet_header.tr,
              style: TEXTSTYLES.kHeaderLarge.copyWith(fontSize: 16.sp),
            ),
            CustomSizes.mediumSizedBoxHeight,
            //verification description
            const VerificationBottomSheetDescription(),
            const Spacer(),
            Column(
              children: [
                CustomButton(
                  onTap: onTap,
                  title: LocaleKeys
                      .registration_WelcomePage_bottomSheet_buttonTitle.tr,
                  titleStyle: TEXTSTYLES.kButtonBasic.copyWith(
                    color: COLORS.kWhiteColor,
                  ),
                  color: COLORS.kGreenMainColor,
                  size: CustomButtonSize.regular,
                  //type: CustomButtonType.outline,
                ),
                CustomSizes.mediumSizedBoxHeight,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      LocaleKeys
                          .registration_WelcomePage_bottomSheet_poweredBy.tr,
                      style: TEXTSTYLES.kBodyBasic.copyWith(fontSize: 12),
                    ),
                    CustomSizes.smallSizedBoxWidth,
                    Assets.svg.corePassTypo.svg(),
                  ],
                ),
                CustomSizes.mediumSizedBoxHeight,
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class VerificationBottomSheetDescription extends StatelessWidget {
  const VerificationBottomSheetDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(
          text: TextSpan(
            text: LocaleKeys.registration_WelcomePage_bottomSheet_body.tr,
            style: TEXTSTYLES.kBodyBasic.copyWith(
              color: COLORS.kTextBlueColor,
            ),
            children: [
              TextSpan(
                text: LocaleKeys
                    .registration_WelcomePage_bottomSheet_privacyPolicy.tr,
                style: TEXTSTYLES.kBodyBasic.copyWith(
                  color: COLORS.kBlueColor,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    //TODO: open privacy policy link
                  },
              ),
            ],
          ),
        ),
        CustomSizes.mediumSizedBoxHeight,
        Text(
          LocaleKeys.registration_WelcomePage_bottomSheet_body2.tr,
          style: TEXTSTYLES.kBodyBasic.copyWith(
            color: COLORS.kTextBlueColor,
          ),
        ),
        Row(
          children: [
            RichText(
              text: TextSpan(
                text:
                    LocaleKeys.registration_WelcomePage_bottomSheet_readMore.tr,
                style: TEXTSTYLES.kBodyBasic.copyWith(
                  color: COLORS.kBlueColor,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    //TODO: open read more link fore corepass id
                  },
                children: [
                  TextSpan(
                    text: LocaleKeys
                        .registration_WelcomePage_bottomSheet_body3.tr,
                    style: TEXTSTYLES.kBodyBasic.copyWith(
                      color: COLORS.kTextBlueColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
