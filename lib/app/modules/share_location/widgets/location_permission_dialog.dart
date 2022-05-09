import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/widgets/custom_button.dart';
import 'package:heyo/app/modules/shared/widgets/modified_alert_dialog.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';

class LocationPermissionDialog extends StatelessWidget {
  const LocationPermissionDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ModifiedAlertDialog(
      hideCloseSign: true,
      alertContent: DefaultAlertDialogContent(
        indicatorIcon: Assets.svg.locationOutlined.svg(
          width: 28.w,
          height: 28.w,
        ),
        indicatorBackgroundColor: COLORS.kGreenLighterColor,
        title: LocaleKeys.permissionDialog_allowAccess.tr,
        subtitle: LocaleKeys.permissionDialog_locationSubtitle.tr,
        buttons: [
          CustomButton(
            title: LocaleKeys.permissionDialog_continue.tr,
            backgroundColor: COLORS.kGreenLighterColor,
            textStyle: TEXTSTYLES.kLinkBig.copyWith(color: COLORS.kGreenMainColor),
            onTap: () => Get.back(result: true),
          ),
          CustomSizes.smallSizedBoxHeight,
          CustomButton(
            title: LocaleKeys.permissionDialog_notNow.tr,
            textStyle: TEXTSTYLES.kLinkBig.copyWith(color: COLORS.kDarkBlueColor),
            onTap: () => Get.back(result: false),
          ),
        ],
      ),
    );
  }
}
