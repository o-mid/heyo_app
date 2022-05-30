import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/widgets/custom_button.dart';
import 'package:heyo/app/modules/shared/widgets/modified_alert_dialog.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';

class DeleteMessageDialog extends StatelessWidget {
  final int toDeleteCount;
  final bool canDeleteForEveryone;
  final Function deleteForEveryone;
  final Function deleteForMe;
  const DeleteMessageDialog({
    Key? key,
    required this.toDeleteCount,
    required this.canDeleteForEveryone,
    required this.deleteForEveryone,
    required this.deleteForMe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ModifiedAlertDialog(
      alertContent: DefaultAlertDialogContent(
        indicatorIcon: Assets.svg.deleteIcon.svg(
          color: COLORS.kDarkBlueColor,
        ),
        indicatorBackgroundColor: COLORS.kBrightBlueColor,
        title: LocaleKeys.MessagesPage_deleteMessagesDialog_title.trPluralParams(
          LocaleKeys.MessagesPage_deleteMessagesDialog_titlePlural,
          toDeleteCount,
          {
            "count": toDeleteCount.toString(),
          },
        ).tr,
        subtitle: LocaleKeys.MessagesPage_deleteMessagesDialog_subtitle.trPlural(
          LocaleKeys.MessagesPage_deleteMessagesDialog_subtitlePlural,
          toDeleteCount,
        ).tr,
        buttons: [
          if (canDeleteForEveryone)
            CustomButton(
              onTap: () {
                deleteForEveryone();
                Get.back();
              },
              title: LocaleKeys.MessagesPage_deleteMessagesDialog_deleteForEveryone.tr,
              textStyle: TEXTSTYLES.kLinkBig.copyWith(color: COLORS.kDarkBlueColor),
              backgroundColor: COLORS.kPinCodeDeactivateColor,
            ),
          if (canDeleteForEveryone) CustomSizes.smallSizedBoxHeight,
          CustomButton(
            onTap: () {
              deleteForMe();
              Get.back();
            },
            title: canDeleteForEveryone
                ? LocaleKeys.MessagesPage_deleteMessagesDialog_deleteForMe.tr
                : LocaleKeys.MessagesPage_deleteMessagesDialog_delete.tr,
            textStyle: TEXTSTYLES.kLinkBig.copyWith(color: COLORS.kDarkBlueColor),
            backgroundColor: COLORS.kPinCodeDeactivateColor,
          ),
          CustomSizes.smallSizedBoxHeight,
          CustomButton(
            onTap: Get.back,
            title: LocaleKeys.MessagesPage_deleteMessagesDialog_cancel.tr,
            textStyle: TEXTSTYLES.kLinkBig.copyWith(color: COLORS.kDarkBlueColor),
          ),
        ],
      ),
    );
  }
}
