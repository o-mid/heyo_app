import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/widgets/custom_button.dart';
import 'package:heyo/app/modules/shared/widgets/modified_alert_dialog.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';

class RemoveContactsDialog extends StatelessWidget {
  const RemoveContactsDialog({required this.userName, super.key});
  final String userName;

  @override
  Widget build(BuildContext context) {
    return ModifiedAlertDialog(
      alertContent: DefaultAlertDialogContent(
        indicatorIcon: Assets.svg.removeContact.svg(
          color: COLORS.kDarkBlueColor,
        ),
        indicatorBackgroundColor: COLORS.kBrightBlueColor,
        titleAlignment: TextAlign.center,
        title: '${LocaleKeys.newChat_userBottomSheet_remove.tr} $userName'
            ' ${LocaleKeys.newChat_userBottomSheet_fromContactsList.tr}',
        buttons: [
          CustomButton(
            onTap: () {
              Get.back(result: true);
            },
            title: LocaleKeys.newChat_userBottomSheet_remove.tr,
            textStyle:
                TEXTSTYLES.kLinkBig.copyWith(color: COLORS.kDarkBlueColor),
            backgroundColor: COLORS.kPinCodeDeactivateColor,
          ),
          CustomSizes.smallSizedBoxHeight,
          CustomButton(
            onTap: () => Get.back(result: false),
            title: LocaleKeys.newChat_userBottomSheet_cancel.tr,
            textStyle:
                TEXTSTYLES.kLinkBig.copyWith(color: COLORS.kDarkBlueColor),
          ),
        ],
      ),
    );
  }
}
