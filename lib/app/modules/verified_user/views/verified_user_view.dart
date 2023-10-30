import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/buttons/custom_button.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/verified_user/controller/verified_user_controller.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';

class VerifiedUserView extends GetView<VerifiedUserController> {
  const VerifiedUserView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Column(
            children: [
              const Spacer(),
              Assets.png.greenChecked.image(width: 56, height: 56),
              CustomSizes.largeSizedBoxHeight,
              Text(
                LocaleKeys.userVerified_title.tr,
                style: TEXTSTYLES.kHeaderDisplay,
              ),
              CustomSizes.largeSizedBoxHeight,
              Text(
                LocaleKeys.userVerified_subtitle.tr,
                style: TEXTSTYLES.kBodyBasic.copyWith(
                  color: COLORS.kTextBlueColor,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              Column(
                children: [
                  CustomButton(
                    onTap: () => controller.buttonAction(),
                    title: LocaleKeys.userVerified_buttonTitle.tr,
                    titleStyle: TEXTSTYLES.kButtonBasic.copyWith(
                      color: COLORS.kWhiteColor,
                    ),
                    color: COLORS.kGreenMainColor,
                    size: CustomButtonSize.regular,
                    //type: CustomButtonType.outline,
                  ),
                  CustomSizes.mediumSizedBoxHeight,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
