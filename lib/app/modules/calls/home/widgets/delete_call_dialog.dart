import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/widgets/custom_button.dart';
import 'package:heyo/app/modules/shared/widgets/modified_alert_dialog.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';

class DeleteCallDialog extends StatelessWidget {
  final VoidCallback deleteCall;
  const DeleteCallDialog({
    Key? key,
    required this.deleteCall,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ModifiedAlertDialog(
      alertContent: DefaultAlertDialogContent(
        indicatorIcon: Assets.svg.deleteIcon.svg(
          color: COLORS.kDarkBlueColor,
        ),
        indicatorBackgroundColor: COLORS.kBrightBlueColor,
        title: LocaleKeys.HomePage_Calls_deleteCallDialog_title.tr,
        buttons: [
          CustomButton(
            onTap: () {
              deleteCall();
              Get.back();
            },
            title: LocaleKeys.HomePage_Calls_deleteCallDialog_delete.tr,
            textStyle:
                TEXTSTYLES.kLinkBig.copyWith(color: COLORS.kDarkBlueColor),
            backgroundColor: COLORS.kPinCodeDeactivateColor,
          ),
          CustomSizes.smallSizedBoxHeight,
          CustomButton(
            onTap: Get.back,
            title: LocaleKeys.HomePage_Calls_deleteCallDialog_cancel.tr,
            textStyle:
                TEXTSTYLES.kLinkBig.copyWith(color: COLORS.kDarkBlueColor),
          ),
        ],
      ),
    );
  }
}
