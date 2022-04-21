import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../../shared/utils/screen-utils/buttons/custom_button.dart';
import '../data/models/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';
import '../../shared/utils/constants/textStyles.dart';
import '../../shared/utils/screen-utils/sizing/custom_sizes.dart';

void openInviteBottomSheet(ProfileModel profile) {
  Get.bottomSheet(
    Container(
      padding: CustomSizes.mainContentPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomSizes.largeSizedBoxHeight,
          Assets.png.chain.image(
            alignment: Alignment.center,
          ),
          CustomSizes.largeSizedBoxHeight,
          Text(LocaleKeys.newChat_inviteBottomSheet_inviteYourFriend.tr,
              style: TEXTSTYLES.kHeaderLarge.copyWith(
                color: COLORS.kDarkBlueColor,
              )),
          CustomSizes.mediumSizedBoxHeight,
          TextButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(
                  text: profile.link,
                )).then((result) {
                  // show toast or snackbar after successfully save

                  Get.rawSnackbar(
                    messageText: Center(
                      child: Text(
                        "Link copied to clipboard",
                        style: TEXTSTYLES.kBodySmall
                            .copyWith(color: COLORS.kDarkBlueColor),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: COLORS.kWhiteColor,
                    snackStyle: SnackStyle.FLOATING,
                    borderRadius: 8,
                    snackPosition: SnackPosition.TOP,
                    maxWidth: 250,
                  );
                });
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(COLORS.kBrightBlueColor),
                padding: MaterialStateProperty.all(
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    profile.link,
                    style: TEXTSTYLES.kLinkBig.copyWith(
                      color: COLORS.kTextBlueColor,
                    ),
                  ),
                  Assets.svg.copyIcon.svg(),
                ],
              )),
          CustomSizes.mediumSizedBoxHeight,
          CustomButton.primary(
            // share the link
            onTap: () {
              Share.share(profile.link);
            },
            color: COLORS.kGreenLighterColor,
            titleWidget: Text(
              LocaleKeys.newChat_inviteBottomSheet_shareLink.tr,
              style: TEXTSTYLES.kLinkBig.copyWith(
                color: COLORS.kGreenMainColor,
              ),
            ),
          ),
          CustomSizes.largeSizedBoxHeight,
        ],
      ),
    ),
    backgroundColor: COLORS.kWhiteColor,
    isDismissible: true,
    enableDrag: true,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20))),
  );
}
