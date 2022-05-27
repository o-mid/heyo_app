import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/new_chat/data/models/new_chat_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/routes/app_pages.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';

import '../../shared/utils/screen-utils/sizing/custom_sizes.dart';

void openNewChatBottomSheet() {
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
            Row(
              children: [
                Expanded(
                  child: TextButton(
                      //Todo: Start new chat onPressed
                      onPressed: () {
                        Get.toNamed(Routes.NEW_CHAT);
                      },
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
                              child: Assets.svg.newChatIcon.svg(width: 20, height: 20),
                            ),
                          ),
                          CustomSizes.mediumSizedBoxWidth,
                          Align(
                              alignment: Alignment.center,
                              child: Text(
                                LocaleKeys.HomePage_bottomSheet_newChat.tr,
                                style: TEXTSTYLES.kBodyBasic.copyWith(
                                  color: COLORS.kDarkBlueColor,
                                ),
                              ))
                        ],
                      )),
                ),
                IconButton(
                    onPressed: () => Get.toNamed(Routes.NEW_CHAT,
                        arguments: NewchatArgumentsModel(
                          openQrScaner: true,
                        )),
                    alignment: Alignment.center,
                    iconSize: 21.w,
                    icon: const Icon(
                      Icons.qr_code_rounded,
                      color: COLORS.kDarkBlueColor,
                    )),
                CustomSizes.smallSizedBoxWidth,
              ],
            ),
            TextButton(
                //Todo: Start new group onPressed
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
                        child: Assets.svg.newGroupIcon.svg(width: 20, height: 20),
                      ),
                    ),
                    CustomSizes.mediumSizedBoxWidth,
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                          LocaleKeys.HomePage_bottomSheet_newGroup.tr,
                          style: TEXTSTYLES.kBodyBasic.copyWith(
                            color: COLORS.kDarkBlueColor,
                          ),
                        ))
                  ],
                )),
            TextButton(
                onPressed: () => Get.toNamed(Routes.NEW_CHAT,
                    arguments: NewchatArgumentsModel(
                      openInviteBottomSheet: true,
                    )),
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
                        child: Assets.svg.inviteIcon.svg(width: 20, height: 20),
                      ),
                    ),
                    CustomSizes.mediumSizedBoxWidth,
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                          LocaleKeys.HomePage_bottomSheet_invite.tr,
                          style: TEXTSTYLES.kBodyBasic.copyWith(
                            color: COLORS.kDarkBlueColor,
                          ),
                        ))
                  ],
                )),
          ]),
    ),
  );
}
