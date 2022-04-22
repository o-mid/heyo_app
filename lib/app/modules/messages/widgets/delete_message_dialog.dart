import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/fonts.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/utils/widgets/modified_alert_dialog.dart';
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
      alertContent: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 64.w,
              height: 64.w,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: COLORS.kBrightBlueColor,
                shape: BoxShape.circle,
              ),
              child: Assets.svg.deleteIcon.svg(
                color: COLORS.kDarkBlueColor,
              ),
            ),
            SizedBox(height: 24.w),
            Text(
              LocaleKeys.MessagesPage_deleteMessagesDialog_title.trPluralParams(
                LocaleKeys.MessagesPage_deleteMessagesDialog_titlePlural,
                toDeleteCount,
                {
                  "count": toDeleteCount.toString(),
                },
              ).tr,
              style: TEXTSTYLES.kHeaderLarge.copyWith(color: COLORS.kDarkBlueColor),
            ),
            CustomSizes.smallSizedBoxHeight,
            Text(
              LocaleKeys.MessagesPage_deleteMessagesDialog_subtitle.trPlural(
                LocaleKeys.MessagesPage_deleteMessagesDialog_subtitlePlural,
                toDeleteCount,
              ).tr,
              style: TEXTSTYLES.kLinkSmall.copyWith(
                fontWeight: FONTS.Regular,
                color: COLORS.kTextBlueColor,
              ),
            ),
            SizedBox(height: 24.w),
            if (canDeleteForEveryone)
              InkWell(
                borderRadius: BorderRadius.circular(8.w),
                onTap: () {
                  deleteForEveryone();
                  Get.back();
                },
                child: Ink(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 9.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.w),
                    color: COLORS.kPinCodeDeactivateColor,
                  ),
                  child: Text(
                    LocaleKeys.MessagesPage_deleteMessagesDialog_deleteForEveryone.tr,
                    style: TEXTSTYLES.kLinkBig.copyWith(color: COLORS.kDarkBlueColor),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            CustomSizes.smallSizedBoxHeight,
            InkWell(
              borderRadius: BorderRadius.circular(8.w),
              onTap: () {
                deleteForMe();
                Get.back();
              },
              child: Ink(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 9.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.w),
                  color: COLORS.kPinCodeDeactivateColor,
                ),
                child: Text(
                  canDeleteForEveryone
                      ? LocaleKeys.MessagesPage_deleteMessagesDialog_deleteForMe.tr
                      : LocaleKeys.MessagesPage_deleteMessagesDialog_delete.tr,
                  style: TEXTSTYLES.kLinkBig.copyWith(color: COLORS.kDarkBlueColor),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            if (canDeleteForEveryone) CustomSizes.smallSizedBoxHeight,
            InkWell(
              borderRadius: BorderRadius.circular(8.w),
              onTap: Get.back,
              child: Ink(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 9.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.w),
                  color: COLORS.kAppBackground,
                ),
                child: Text(
                  LocaleKeys.MessagesPage_deleteMessagesDialog_cancel.tr,
                  style: TEXTSTYLES.kLinkBig.copyWith(color: COLORS.kDarkBlueColor),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
