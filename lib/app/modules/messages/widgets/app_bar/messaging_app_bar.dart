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
import '../../../new_chat/widgets/user_preview_bottom_sheet.dart';
import '../../../shared/data/models/messages_view_arguments_model.dart';

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
                : _DefaultAppBar(user: controller.args.user),
          ),
        ),
      ),
    );
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
  final UserModel user;
  const _DefaultAppBar({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MessagesController>();
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
        CustomCircleAvatar(url: user.iconUrl, size: 32, isOnline: user.isOnline),
        CustomSizes.smallSizedBoxWidth,
        GestureDetector(
          onTap: () => openUserPreviewBottomSheet(user),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      user.name,
                      style: TEXTSTYLES.kButtonBasic.copyWith(
                        color: COLORS.kWhiteColor,
                        height: 1,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    if (user.isVerified)
                      Assets.svg.verified.svg(
                        width: 12.w,
                        height: 12.w,
                        color: COLORS.kWhiteColor,
                      ),
                  ],
                ),
              ),
              if (user.isOnline)
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
                    controller.connectionType == MessagingConnectionType.internet
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
              if (!user.isOnline)
                Text(
                  LocaleKeys.offline.tr,
                  style: TEXTSTYLES.kBodyTag.copyWith(
                    color: COLORS.kWhiteColor,
                    fontWeight: FONTS.Regular,
                  ),
                ),
              if (user.isOnline)
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.MessagesPage_onlineVia.tr,
                      style: TEXTSTYLES.kBodyTag.copyWith(
                        color: COLORS.kWhiteColor,
                        fontWeight: FONTS.Regular,
                      ),
                    ),
                    SizedBox(width: 4.w),

                    // Todo: show connection method correctly
                    Icon(
                      Icons.wifi,
                      size: 12.w,
                      color: COLORS.kWhiteColor,
                    ),
                    SizedBox(width: 4.w),
                    Assets.svg.lunaConnection.svg(
                      width: 10.w,
                      height: 10.w,
                    ),
                  ],
                ),
              if (!user.isOnline)
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
                      session: null,
                      callId: null,
                      user: user,
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
                  Routes.CALL,
                  arguments: CallViewArgumentsModel(
                      session: null,
                      callId: null,
                      user: user,
                      enableVideo: false,
                      isAudioCall: true),
                );
              },
              backgroundColor: Colors.transparent,
              icon: Assets.svg.audioCallIcon.svg(),
            ),
            CustomSizes.smallSizedBoxWidth,
            Assets.svg.verticalMenuIcon.svg(),
          ],
        ),
      ],
    );
  }
}
