import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:heyo/app/modules/intro/controllers/intro_controller.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/fonts.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/buttons/custom_button.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';

class IntroView extends GetView<IntroController> {
  const IntroView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLORS.kGreenMainColor,
      body: SafeArea(
        child: Padding(
          padding: CustomSizes.mainContentPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Assets.png.welcome.image(
                      alignment: Alignment.center,
                    ),
                    Column(
                      children: [
                        Text(
                          LocaleKeys.registration_WelcomePage_title.tr,
                          style: TEXTSTYLES.kHeaderDisplay,
                          textAlign: TextAlign.center,
                        ),
                        CustomSizes.mediumSizedBoxHeight,
                        Text(
                          LocaleKeys.registration_WelcomePage_subtitle.tr,
                          style: TEXTSTYLES.kBodyBasic,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomButton(
                      //TODO : Implement Continue with CoreID
                      onTap: () =>
                          controller.openCorePassVerificationBottomSheet(),
                      //onTap: () => Get.toNamed(Routes.SING_UP),

                      title: LocaleKeys
                          .registration_WelcomePage_buttons_Continue.tr,
                      titleStyle: TEXTSTYLES.kButtonBasic
                          .copyWith(color: COLORS.kGreenMainColor),
                      color: COLORS.kWhiteColor,
                      size: CustomButtonSize.regular,
                      type: CustomButtonType.outline,
                    ),
                    CustomButton(
                      //TODO : Implement Terms and privacy policy
                      onTap: () {},
                      title:
                          LocaleKeys.registration_WelcomePage_buttons_Terms.tr,
                      titleStyle: TEXTSTYLES.kButtonSmall.copyWith(
                        color: COLORS.kTextGreenButtonColor,
                        fontWeight: FONTS.Light,
                      ),
                      size: CustomButtonSize.regular,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
