import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model.dart';
import 'package:heyo/app/modules/shared/data/models/messages_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';

import '../../../routes/app_pages.dart';
import '../../shared/data/models/add_contacts_view_arguments_model.dart';
import '../../shared/utils/constants/textStyles.dart';
import '../../shared/utils/screen-utils/sizing/custom_sizes.dart';
import '../../shared/widgets/curtom_circle_avatar.dart';

void openUserPreviewBottomSheet(UserModel user) {
  Get.bottomSheet(
    Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomSizes.largeSizedBoxHeight,
        CustomCircleAvatar(url: user.icon, size: 64),
        CustomSizes.mediumSizedBoxHeight,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              user.name,
              style: TEXTSTYLES.kHeaderLarge.copyWith(color: COLORS.kDarkBlueColor),
            ),
            CustomSizes.smallSizedBoxWidth,
            user.isVerified
                ? Assets.svg.verifiedWithBluePadding
                    .svg(alignment: Alignment.center, height: 24.w, width: 24.w)
                : const SizedBox(),
          ],
        ),
        CustomSizes.smallSizedBoxHeight,
        Text(
          user.walletAddress,
          style: TEXTSTYLES.kBodySmall.copyWith(color: COLORS.kTextBlueColor),
        ),
        CustomSizes.smallSizedBoxHeight,
        Padding(
          padding: CustomSizes.iconListPadding,
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomSizes.smallSizedBoxHeight,
                TextButton(
                    //Todo: Add User Info onPressed
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
                            child: Assets.svg.infoIcon.svg(width: 20, height: 20),
                          ),
                        ),
                        CustomSizes.mediumSizedBoxWidth,
                        Align(
                            alignment: Alignment.center,
                            child: Text(
                              LocaleKeys.newChat_userBottomSheet_userInfo.tr,
                              style: TEXTSTYLES.kLinkBig.copyWith(
                                color: COLORS.kDarkBlueColor,
                              ),
                            ))
                      ],
                    )),
                TextButton(
                    onPressed: () {
                      if (user.chatModel == null) {
                        return;
                      }
                      Get.toNamed(Routes.MESSAGES,
                          arguments: MessagesViewArgumentsModel(chat: user.chatModel!));
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
                              LocaleKeys.newChat_userBottomSheet_chat.tr,
                              style: TEXTSTYLES.kLinkBig.copyWith(
                                color: COLORS.kDarkBlueColor,
                              ),
                            ))
                      ],
                    )),
                TextButton(
                    //Todo: Add To Contacts onPressed
                    onPressed: () {
                      Get.toNamed(
                        Routes.ADD_CONTACTS,
                        arguments: AddContactsViewArgumentsModel(user: user),
                      );
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
                            child: Assets.svg.addToContactsIcon.svg(width: 20, height: 20),
                          ),
                        ),
                        CustomSizes.mediumSizedBoxWidth,
                        Align(
                            alignment: Alignment.center,
                            child: Text(
                              LocaleKeys.newChat_userBottomSheet_addToContacts.tr,
                              style: TEXTSTYLES.kLinkBig.copyWith(
                                color: COLORS.kDarkBlueColor,
                              ),
                            ))
                      ],
                    )),
                TextButton(
                    //Todo: Block onPressed
                    onPressed: () {},
                    child: Row(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: COLORS.kStatesErrorBackgroundColor,
                            ),
                            child: Assets.svg.blockIcon.svg(width: 20, height: 20),
                          ),
                        ),
                        CustomSizes.mediumSizedBoxWidth,
                        Align(
                            alignment: Alignment.center,
                            child: Text(
                              LocaleKeys.newChat_userBottomSheet_block.tr,
                              style: TEXTSTYLES.kLinkBig.copyWith(
                                color: COLORS.kStatesErrorColor,
                              ),
                            ))
                      ],
                    )),
                CustomSizes.largeSizedBoxHeight,
              ]),
        ),
      ],
    ),
    backgroundColor: COLORS.kWhiteColor,
    isDismissible: true,
    isScrollControlled: true,
    enableDrag: true,
    shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
  );
}
