import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/widgets/custom_button.dart';
import 'package:heyo/app/modules/shared/widgets/modified_alert_dialog.dart';
import 'package:heyo/generated/locales.g.dart';

Future<bool?> showCustomDialog(
  BuildContext context, {
  required Widget indicatorIcon,
  required String confirmTitle,
  required String title,
  void Function()? onConfirm,
  void Function()? onCancel,
}) async {
  return showDialog<bool?>(
    context: context,
    builder: (context) => CustomDialogWidget(
      indicatorIcon: indicatorIcon,
      onConfirm: onConfirm,
      confirmTitle: confirmTitle,
      title: title,
    ),
  );
}

class CustomDialogWidget extends StatelessWidget {
  const CustomDialogWidget({
    required this.indicatorIcon,
    required this.confirmTitle,
    required this.title,
    this.onConfirm,
    super.key,
  });
  final Widget indicatorIcon;
  final String confirmTitle;
  final String title;
  final void Function()? onConfirm;

  @override
  Widget build(BuildContext context) {
    return ModifiedAlertDialog(
      alertContent: DefaultAlertDialogContent(
        indicatorIcon: indicatorIcon,
        indicatorBackgroundColor: COLORS.kBrightBlueColor,
        title: title,
        titleAlignment: TextAlign.center,
        buttons: [
          CustomButton(
            onTap: onConfirm ?? Get.back<void>,
            title: confirmTitle,
            textStyle:
                TEXTSTYLES.kLinkBig.copyWith(color: COLORS.kDarkBlueColor),
            backgroundColor: COLORS.kPinCodeDeactivateColor,
          ),
          CustomSizes.smallSizedBoxHeight,
          CustomButton(
            onTap: Get.back<void>,
            title: LocaleKeys.HomePage_Calls_deleteAllCallsDialog_cancel.tr,
            textStyle:
                TEXTSTYLES.kLinkBig.copyWith(color: COLORS.kDarkBlueColor),
          ),
        ],
      ),
    );
  }
}
