import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/buttons/custom_button.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/widgets/modified_alert_dialog.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';

class PermissionDialog extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget indicatorIcon;
  const PermissionDialog(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.indicatorIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ModifiedAlertDialog(
      hideCloseSign: true,
      alertContent: DefaultAlertDialogContent(
        indicatorIcon: Assets.svg.arrowIcon.svg(
          width: 28.w,
          height: 28.w,
        ),
        indicatorBackgroundColor: COLORS.kGreenLighterColor,
        title: title,
        subtitle: subtitle,
        buttons: [
          CustomButton(
            title: LocaleKeys.Permissions_buttons_Continue.tr,
            color: COLORS.kGreenLighterColor,
            titleStyle:
                TEXTSTYLES.kLinkBig.copyWith(color: COLORS.kGreenMainColor),
            onTap: () => Get.back(result: true),
            size: CustomButtonSize.regular,
          ),
          CustomSizes.smallSizedBoxHeight,
          CustomButton(
            title: LocaleKeys.Permissions_buttons_Notnow.tr,
            titleStyle:
                TEXTSTYLES.kLinkBig.copyWith(color: COLORS.kDarkBlueColor),
            onTap: () => Get.back(result: false),
            size: CustomButtonSize.regular,
          ),
        ],
      ),
    );
  }
}
