import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:heyo/app/modules/calls/shared/data/models/call_user_model.dart';
import 'package:heyo/app/modules/messages/controllers/messages_controller.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model/user_model.dart';
import 'package:heyo/app/modules/shared/data/models/add_contacts_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/data/models/call_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/data/models/messages_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/fonts.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/widgets/circle_icon_button.dart';
import 'package:heyo/app/modules/shared/widgets/curtom_circle_avatar.dart';
import 'package:heyo/app/modules/shared/widgets/scale_animated_switcher.dart';
import 'package:heyo/app/routes/app_pages.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';

class MessagingAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MessagingAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MessagesController>();
    // Material is used here so that splash can be seen
    return Material(
      color: COLORS.kGreenMainColor,
      child: Container(
        padding: EdgeInsets.only(top: 12.h, bottom: 12.h, right: 20.w),
        child: SafeArea(
          child: ScaleAnimatedSwitcher(
            child: controller.selectedMessages.isNotEmpty
                ? const _SelectionModeAppBar()
                : const _DefaultAppBar(),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size(AppBar().preferredSize.width.w, AppBar().preferredSize.height.w);
}

class _SelectionModeAppBar extends StatelessWidget {
  const _SelectionModeAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MessagesController>();
    return Row(
      children: [
        IconButton(
          splashRadius: 20.r,
          padding: EdgeInsets.zero,
          onPressed: () {
            controller.clearSelected();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: COLORS.kWhiteColor,
          ),
        ),
        Text(
          LocaleKeys.MessagesPage_countSelectedMessages.trParams({
            "count": controller.selectedMessages.length.toString(),
          }),
          style: TEXTSTYLES.kHeaderLarge.copyWith(color: COLORS.kWhiteColor),
        ),
      ],
    );
  }
}

class _DefaultAppBar extends StatelessWidget {
  const _DefaultAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MessagesController>();
    return Obx(() {
      return Row(
        children: [
          CircleIconButton(
            backgroundColor: Colors.transparent,
            onPressed: Get.back,
            icon: const Icon(
              Icons.arrow_back,
              color: COLORS.kWhiteColor,
            ),
          ),
          CustomCircleAvatar(
              coreId: controller.user.value.coreId,
              size: 32,
              isOnline: controller.user.value.isOnline),
          CustomSizes.smallSizedBoxWidth,
          GestureDetector(
            onDoubleTap: controller.saveCoreIdToClipboard,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        controller.user.value.name,
                        style: TEXTSTYLES.kButtonBasic.copyWith(
                          color: COLORS.kWhiteColor,
                          height: 1,
                        ),
                      ),
                      SizedBox(width: 5.w),
                      if (controller.user.value.isVerified)
                        Assets.svg.verified.svg(
                          width: 12.w,
                          height: 12.w,
                          color: COLORS.kWhiteColor,
                        ),
                    ],
                  ),
                ),
                if (controller.user.value.isOnline)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        LocaleKeys.MessagesPage_onlineVia.tr,
                        style: TEXTSTYLES.kBodyTag.copyWith(
                          color: COLORS.kWhiteColor,
                          fontWeight: FONTS.Regular,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      controller.connectionType ==
                              MessagingConnectionType.internet
                          ? Icon(
                              Icons.wifi,
                              size: 12.w,
                              color: COLORS.kWhiteColor,
                            )
                          : Assets.svg.wifiDirectIcon.svg(
                              height: 10.w,
                              fit: BoxFit.contain,
                              alignment: Alignment.center,
                              color: COLORS.kWhiteColor,
                            ),
                    ],
                  ),
                if (controller.user.value.isOnline == false)
                  Text(
                    LocaleKeys.offline.tr,
                    style: TEXTSTYLES.kBodyTag.copyWith(
                      color: COLORS.kWhiteColor,
                      fontWeight: FONTS.Regular,
                    ),
                  ),
              ],
            ),
          ),
          const Spacer(),
          Row(
            children: [
              CircleIconButton(
                onPressed: () {
                  Get.toNamed(
                    Routes.CALL,
                    arguments: CallViewArgumentsModel(
                        callId: null,
                        members: [controller.getUser().coreId],
                        isAudioCall: false),
                  );
                },
                icon: Assets.svg.videoCallIcon.svg(),
                backgroundColor: Colors.transparent,
              ),
              CircleIconButton(
                onPressed: () {
                  Get.toNamed(
                    Routes.CALL,
                    arguments: CallViewArgumentsModel(
                        callId: null,
                        members: [controller.getUser().coreId],
                        isAudioCall: true),
                  );
                },
                backgroundColor: Colors.transparent,
                icon: Assets.svg.audioCallIcon.svg(),
              ),
              CircleIconButton(
                backgroundColor: Colors.transparent,
                padding: const EdgeInsets.all(0),
                icon: Assets.svg.verticalMenuIcon.svg(),
                size: 22,
                onPressed: () {
                  _openAppBarActionBottomSheet(userModel: controller.getUser());
                },
              ),
            ],
          ),
        ],
      );
    });
  }
}

void _openAppBarActionBottomSheet({required UserModel userModel}) {
  Get.bottomSheet(
      Padding(
        padding: CustomSizes.iconListPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () {
                Get..back()
                ..toNamed(
                  Routes.ADD_CONTACTS,
                  arguments: AddContactsViewArgumentsModel(
                    coreId: userModel.coreId,
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
                    child:
                        userModel.isContact ? Assets.svg.infoIcon.svg(width: 20, height: 20) : Assets.svg.addToContactsIcon.svg(width: 20, height: 20),
                  ),
                  CustomSizes.mediumSizedBoxWidth,
                  Text(
                    userModel.isContact ? LocaleKeys.AddContacts_Edit_Contact.tr : LocaleKeys.newChat_userBottomSheet_addToContacts.tr,
                    style: TEXTSTYLES.kLinkBig.copyWith(
                      color: COLORS.kDarkBlueColor,
                    ),
                  )
                ],
              ),
            ),
            CustomSizes.mediumSizedBoxHeight,
          ],
        ),
      ),
      backgroundColor: COLORS.kWhiteColor,
      isDismissible: true,
      enableDrag: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))));
}
