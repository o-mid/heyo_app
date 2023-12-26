import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heyo/app/modules/chats/data/models/chat_model.dart';
import 'package:heyo/app/modules/messages/controllers/messages_controller.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model.dart';
import 'package:heyo/app/modules/shared/data/models/call_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/fonts.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/widgets/circle_icon_button.dart';
import 'package:heyo/app/modules/shared/widgets/curtom_circle_avatar.dart';
import 'package:heyo/app/modules/shared/widgets/scale_animated_switcher.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';
import 'package:get/get.dart';

import '../../../../routes/app_pages.dart';
import '../../../shared/data/models/add_contacts_view_arguments_model.dart';
import '../../../shared/data/models/messages_view_arguments_model.dart';
import '../../../shared/widgets/stacked_avatars_widget.dart';

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
        ));
  }

  @override
  Size get preferredSize => Size(AppBar().preferredSize.width.w, AppBar().preferredSize.height.w);
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
          if (controller.isGroupChat)
            StackedAvatars(
              avatarSize: 24,
              coreId1: controller.participants.first.coreId,
              coreId2: controller.participants.last.coreId,
            )
          else
            CustomCircleAvatar(
                coreId: controller.users.first.coreId,
                size: 32,
                isOnline: controller.users.first.isOnline),
          CustomSizes.smallSizedBoxWidth,
          GestureDetector(
            onDoubleTap: controller.saveCoreIdToClipboard,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _BuildChatName(
                  name: controller.chatName.value,
                  isVerified: controller.users.first.isVerified && !controller.isGroupChat,
                ),
                _BuildUserStatus(
                  isGroupChat: controller.isGroupChat,
                  membersCount: controller.participants.length,
                  isOnline: controller.users.first.isOnline,
                  connectionType: controller.connectionType,
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
                    // TODO : GROUP CALL
                    Routes.CALL,
                    arguments: CallViewArgumentsModel(
                        session: null,
                        callId: null,
                        user: controller.users.first,
                        enableVideo: true,
                        isAudioCall: false),
                  );
                },
                icon: Assets.svg.videoCallIcon.svg(),
                backgroundColor: Colors.transparent,
              ),
              CircleIconButton(
                onPressed: () {
                  Get.toNamed(
                    // TODO : GROUP CALL
                    Routes.CALL,
                    arguments: CallViewArgumentsModel(
                        session: null,
                        callId: null,
                        user: controller.users.first,
                        enableVideo: false,
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
                  _openAppBarActionBottomSheet(userModel: controller.users.first);
                },
              ),
            ],
          ),
        ],
      );
    });
  }
}

class _BuildUserStatus extends StatelessWidget {
  final MessagingConnectionType connectionType;
  final bool isOnline;
  final bool isGroupChat;
  final int membersCount;

  const _BuildUserStatus({
    required this.isOnline,
    required this.isGroupChat,
    required this.membersCount,
    this.connectionType = MessagingConnectionType.internet,
  });

  @override
  Widget build(BuildContext context) {
    if (isGroupChat) {
      return Text(
        membersCount.toString() + " " + "members",
        style: TEXTSTYLES.kBodyTag.copyWith(
          color: COLORS.kWhiteColor,
          fontWeight: FONTS.Regular,
          fontSize: 12.0.sp,
        ),
      );
    } else {
      if (isOnline) {
        return Row(
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
            if (connectionType == MessagingConnectionType.internet)
              Icon(
                Icons.wifi,
                size: 12.w,
                color: COLORS.kWhiteColor,
              )
            else
              Assets.svg.wifiDirectIcon.svg(
                height: 10.w,
                fit: BoxFit.contain,
                alignment: Alignment.center,
                color: COLORS.kWhiteColor,
              ),
          ],
        );
      } else {
        return Text(
          LocaleKeys.offline.tr,
          style: TEXTSTYLES.kBodyTag.copyWith(
            color: COLORS.kWhiteColor,
            fontWeight: FONTS.Regular,
          ),
        );
      }
    }
  }
}

class _BuildChatName extends StatelessWidget {
  final String name;
  final bool isVerified;
  _BuildChatName({
    required this.name,
    Key? key,
    this.isVerified = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Text(
            name,
            style: TEXTSTYLES.kButtonBasic.copyWith(
              color: COLORS.kWhiteColor,
              height: 1,
            ),
          ),
          SizedBox(width: 5.w),
          if (isVerified)
            Assets.svg.verified.svg(
              width: 12.w,
              height: 12.w,
              color: COLORS.kWhiteColor,
            ),
        ],
      ),
    );
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
                Get.back();

                Get.toNamed(
                  Routes.ADD_CONTACTS,
                  arguments: AddContactsViewArgumentsModel(
                    //  user: userModel,
                    coreId: userModel.coreId,
                    iconUrl: userModel.coreId,
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
                    child: Assets.svg.addToContactsIcon.svg(width: 20, height: 20),
                  ),
                  CustomSizes.mediumSizedBoxWidth,
                  Text(
                    LocaleKeys.newChat_userBottomSheet_addToContacts.tr,
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
          borderRadius:
              BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))));
}
