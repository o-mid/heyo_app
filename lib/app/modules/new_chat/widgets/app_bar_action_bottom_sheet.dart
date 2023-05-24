import 'package:get/get.dart';
import 'package:heyo/app/modules/new_chat/widgets/invite_bttom_sheet.dart';
import '../../shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:flutter/material.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';
import '../../shared/utils/constants/textStyles.dart';

void openAppBarActionBottomSheet({
  required String profileLink,
}) {
  Get.bottomSheet(
      Padding(
        padding: CustomSizes.iconListPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
                onPressed: () {
                  Get.back();
                  openInviteBottomSheet(profileLink: profileLink);
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
                        child: Assets.svg.inviteIcon.svg(width: 20, height: 20),
                      ),
                    ),
                    CustomSizes.mediumSizedBoxWidth,
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                          LocaleKeys.newChat_buttons_invite.tr,
                          style: TEXTSTYLES.kLinkBig.copyWith(
                            color: COLORS.kDarkBlueColor,
                          ),
                        ))
                  ],
                )),
            CustomSizes.mediumSizedBoxHeight,
          ],
        ),
      ),
      backgroundColor: COLORS.kWhiteColor,
      isDismissible: true,
      enableDrag: true,
      shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))));
}
