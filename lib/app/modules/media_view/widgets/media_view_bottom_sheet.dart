import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/fonts.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';

void openMediaViewBottomSheet() {
  Get.bottomSheet(
    backgroundColor: COLORS.kWhiteColor,
    isDismissible: true,
    persistent: true,
    enableDrag: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    Padding(
      padding: CustomSizes.mainContentPadding,
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomSizes.smallSizedBoxHeight,
            TextButton(
                //Todo: editIcon onPressed
                onPressed: () {},
                child: Row(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: COLORS.kBrightBlueColor,
                        ),
                        child: Assets.svg.editIcon.svg(
                            width: 20,
                            height: 20,
                            color: COLORS.kDarkBlueColor),
                      ),
                    ),
                    CustomSizes.mediumSizedBoxWidth,
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                          LocaleKeys.mediaView_bottomSheet_edit.tr,
                          style: TEXTSTYLES.kBodyBasic.copyWith(
                            color: COLORS.kDarkBlueColor,
                            fontWeight: FONTS.Medium,
                          ),
                        ))
                  ],
                )),
            TextButton(
                //Media and files onPressed
                onPressed: () {},
                child: Row(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: COLORS.kBrightBlueColor,
                        ),
                        child: Assets.svg.mediaAndFilesIcon.svg(
                            width: 20,
                            height: 20,
                            color: COLORS.kDarkBlueColor),
                      ),
                    ),
                    CustomSizes.mediumSizedBoxWidth,
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                          LocaleKeys.mediaView_bottomSheet_mediafiles.tr,
                          style: TEXTSTYLES.kBodyBasic.copyWith(
                            color: COLORS.kDarkBlueColor,
                            fontWeight: FONTS.Medium,
                          ),
                        ))
                  ],
                )),
            TextButton(
                //Todo: share onPressed
                onPressed: () {},
                child: Row(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: COLORS.kBrightBlueColor,
                        ),
                        child: Assets.svg.shareIcon.svg(
                            width: 20,
                            height: 20,
                            color: COLORS.kDarkBlueColor),
                      ),
                    ),
                    CustomSizes.mediumSizedBoxWidth,
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                          LocaleKeys.mediaView_bottomSheet_share.tr,
                          style: TEXTSTYLES.kBodyBasic.copyWith(
                            color: COLORS.kDarkBlueColor,
                            fontWeight: FONTS.Medium,
                          ),
                        ))
                  ],
                )),
            TextButton(
                //Todo: savw onPressed
                onPressed: () {},
                child: Row(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: COLORS.kBrightBlueColor,
                        ),
                        child: Assets.svg.saveToDevice.svg(
                            width: 20,
                            height: 20,
                            color: COLORS.kDarkBlueColor),
                      ),
                    ),
                    CustomSizes.mediumSizedBoxWidth,
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                          LocaleKeys.mediaView_bottomSheet_save.tr,
                          style: TEXTSTYLES.kBodyBasic.copyWith(
                            color: COLORS.kDarkBlueColor,
                            fontWeight: FONTS.Medium,
                          ),
                        ))
                  ],
                )),
            TextButton(
                //Todo: delete onPressed
                onPressed: () {},
                child: Row(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: COLORS.kBrightBlueColor,
                        ),
                        child: Assets.svg.deleteIcon.svg(
                            width: 20,
                            height: 20,
                            color: COLORS.kDarkBlueColor),
                      ),
                    ),
                    CustomSizes.mediumSizedBoxWidth,
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                          LocaleKeys.mediaView_bottomSheet_delete.tr,
                          style: TEXTSTYLES.kBodyBasic.copyWith(
                            color: COLORS.kDarkBlueColor,
                            fontWeight: FONTS.Medium,
                          ),
                        ))
                  ],
                )),
          ]),
    ),
  );
}
