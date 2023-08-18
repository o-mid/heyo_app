import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/new_chat/data/models/new_chat_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/routes/app_pages.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';

import '../../shared/utils/constants/transitions_constant.dart';
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
    enterBottomSheetDuration: TRANSITIONS.chatsPage_EnterBottomSheetDuration,
    exitBottomSheetDuration: TRANSITIONS.chatsPage_ExitBottomSheetDuration,
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
                // NEW CHAT BUTTON
                child: TextButton(
                  //Todo: Start new chat onPressed
                  onPressed: () {
                    Get.back();
                    Get.toNamed(Routes.NEW_CHAT);
                  },
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: COLORS.kBrightBlueColor,
                        ),
                        child: Assets.svg.chatOutlined.svg(
                          width: 20,
                          height: 20,
                          color: COLORS.kDarkBlueColor,
                        ),
                      ),
                      CustomSizes.mediumSizedBoxWidth,
                      Text(
                        LocaleKeys.HomePage_bottomSheet_newChat.tr,
                        style: TEXTSTYLES.kBodyBasic.copyWith(
                          color: COLORS.kDarkBlueColor,
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Get.back();
                  Get.toNamed(
                    Routes.NEW_CHAT,
                    arguments: NewChatArgumentsModel(
                      openQrScanner: true,
                    ),
                  );
                },
                alignment: Alignment.center,
                iconSize: 21.w,
                icon: Assets.svg.qrCode.svg(
                  width: 20.w,
                  fit: BoxFit.fitWidth,
                  color: COLORS.kDarkBlueColor,
                ),
              ),
              //CustomSizes.smallSizedBoxWidth,
            ],
          ),
          // WIFI_DIRECT BUTTON
          TextButton(
            onPressed: () => Get.toNamed(
              Routes.WIFI_DIRECT,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: COLORS.kBrightBlueColor,
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Assets.svg.wifiDirectIcon.svg(
                      width: 20.w,
                      fit: BoxFit.fitWidth,
                      color: COLORS.kDarkBlueColor,
                    ),
                  ),
                ),
                CustomSizes.mediumSizedBoxWidth,
                Text(
                  LocaleKeys.HomePage_bottomSheet_wifiDirect.tr,
                  style: TEXTSTYLES.kBodyBasic.copyWith(
                    color: COLORS.kDarkBlueColor,
                    fontSize: 16,
                  ),
                )
              ],
            ),
          ),
          // NEW GROUP BUTTON
          TextButton(
            //Todo: Start new group onPressed
            onPressed: () {},
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: COLORS.kBrightBlueColor,
                  ),
                  child: Assets.svg.newGroupIcon.svg(width: 20, height: 20),
                ),
                CustomSizes.mediumSizedBoxWidth,
                Text(
                  LocaleKeys.HomePage_bottomSheet_newGroup.tr,
                  style: TEXTSTYLES.kBodyBasic.copyWith(
                    color: COLORS.kDarkBlueColor,
                    fontSize: 16,
                  ),
                )
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              Get.toNamed(
                Routes.NEW_CHAT,
                arguments: NewChatArgumentsModel(
                  openInviteBottomSheet: true,
                ),
              );
            },
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: COLORS.kBrightBlueColor,
                  ),
                  child: Assets.svg.inviteIcon.svg(width: 20, height: 20),
                ),
                CustomSizes.mediumSizedBoxWidth,
                Text(
                  LocaleKeys.HomePage_bottomSheet_invite.tr,
                  style: TEXTSTYLES.kBodyBasic.copyWith(
                    color: COLORS.kDarkBlueColor,
                    fontSize: 16,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
