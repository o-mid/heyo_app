import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/buttons/custom_button.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/routes/app_pages.dart';
import 'package:heyo/generated/locales.g.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../shared/utils/constants/colors.dart';
import '../controllers/pin_code_controller.dart';

class PinCodeView extends GetView<PinCodeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: COLORS.kWhiteColor,
        body: Container(
          padding: CustomSizes.mainContentPadding,
          child: Obx(
            () {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    LocaleKeys.registration_PINcodePage_title.tr,
                    style: TEXTSTYLES.kHeaderDisplay,
                  ),
                  CustomSizes.mediumSizedBoxHeight,
                  Text(
                    LocaleKeys.registration_PINcodePage_subtitle.tr,
                    textAlign: TextAlign.center,
                    style: TEXTSTYLES.kButtonBasic.copyWith(
                      color: COLORS.kTextSoftBlueColor,
                    ),
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  Text(
                    // cheack if the pin needs to repeate and return the correct text
                    controller.typeAgain.value
                        ? LocaleKeys.registration_PINcodePage_pinRepeat.tr
                        : LocaleKeys.registration_PINcodePage_pinType.tr,
                    style: TEXTSTYLES.kBodySmall
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  CustomSizes.mediumSizedBoxHeight,
                  PinCodeTextField(
                    controller: controller.pinCodeController,
                    onCompleted: (CompletedText) {
                      // print("Completed");
                      // print(CompletedText);
                      controller.onCompleted(CompletedText);
                    },
                    inputFormatters: [
                      // only allow english numbers to be entered (0-9)
                      FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                    ],
                    onChanged: (String value) {},
                    length: 6,
                    obscureText: true,
                    animationType: AnimationType.slide,
                    autoFocus: true,
                    keyboardType: TextInputType.number,
                    useHapticFeedback: true,
                    obscuringCharacter: '*',
                    autoDismissKeyboard: false,
                    textStyle: TEXTSTYLES.kHeaderDisplay,
                    pinTheme: pinTheme(),
                    animationDuration: Duration(milliseconds: 250),
                    appContext: context,
                  ),
                ],
              );
            },
          ),
        ));
  }

  PinTheme pinTheme() {
    return PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(5),
        fieldHeight: 56,
        fieldWidth: 40,
        borderWidth: 1.0,
        selectedColor: COLORS.kGreenMainColor,
        activeFillColor: COLORS.kWhiteColor,
        disabledColor: COLORS.kPinCodeDeactivateColor,
        inactiveColor: COLORS.kPinCodeDeactivateColor,
        inactiveFillColor: COLORS.kPinCodeDeactivateColor,
        activeColor: COLORS.kGreenMainColor);
  }
}

Widget bottomSheet = Container(
  padding: CustomSizes.mainContentPadding,
  child: Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SizedBox(
        height: 40.h,
      ),
      Text(LocaleKeys.registration_PINcodePage_dialogTitle.tr,
          style: TEXTSTYLES.kHeaderMedium),
      CustomSizes.largeSizedBoxHeight,
      CustomButton.primary(
        title: LocaleKeys.registration_PINcodePage_buttons_AddBiometric.tr,
        // TODO: implement the add biometric
        onTap: () {},
        canTap: true,
        icon: Icon(
          Icons.fingerprint,
          color: COLORS.kWhiteColor,
        ),
      ),
      CustomButton(
        // TODO: implement the steps with the biometric
        onTap: () {
          Get.toNamed(Routes.GENERATE_PRIVATE_KEYS);
        },
        title: LocaleKeys.registration_PINcodePage_buttons_SkipBiometric.tr,
        titleStyle:
            TEXTSTYLES.kButtonSmall.copyWith(color: COLORS.kGreenMainColor),
        size: CustomButtonSize.regular,
      ),
    ],
  ),
);
