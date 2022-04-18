import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/buttons/custom_button.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/routes/app_pages.dart';
import 'package:heyo/generated/locales.g.dart';
import '../../../../generated/assets.gen.dart';
import '../controllers/intro_controller.dart';

class IntroView extends GetView<IntroController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLORS.kGreenMainColor,
      body: Container(
        padding: CustomSizes.mainContentPadding,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Assets.png.welcome.image(
                    alignment: Alignment.center,
                  ),
                  Text(
                    LocaleKeys.registration_WelcomePage_title.tr,
                    style: TEXTSTYLES.kHeaderDisplay,
                    textAlign: TextAlign.center,
                  ),
                  CustomSizes.mediumSizedBoxHeight,
                  Text(
                    LocaleKeys.registration_WelcomePage_subtitle.tr,
                    style: TEXTSTYLES.kBodyTag,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                    //TODO : Implement Continue with CoreID
                    onTap: () {
                      Get.toNamed(Routes.SING_UP);
                    },
                    title: LocaleKeys.registration_WelcomePage_buttons_Continue.tr,
                    titleStyle: TEXTSTYLES.kButtonBasic.copyWith(color: COLORS.kGreenMainColor),
                    color: COLORS.kWhiteColor,
                    size: CustomButtonSize.regular,
                    type: CustomButtonType.outline,
                  ),
                  CustomButton(
                    //TODO : Implement Terms and privacy policy
                    onTap: () {},
                    title: LocaleKeys.registration_WelcomePage_buttons_Terms.tr,
                    titleStyle: TEXTSTYLES.kButtonSmall.copyWith(color: COLORS.kDarkBlueColor),
                    size: CustomButtonSize.regular,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
