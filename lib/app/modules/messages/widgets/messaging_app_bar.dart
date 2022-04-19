import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heyo/app/modules/chats/data/models/chat_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/fonts.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/utils/widgets/curtom_circle_avatar.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';
import 'package:get/get.dart';

class MessagingAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ChatModel chat;
  const MessagingAppBar({Key? key, required this.chat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
      color: COLORS.kGreenMainColor,
      child: SafeArea(
        child: Row(
          children: [
            CustomCircleAvatar(url: chat.icon, size: 32, isOnline: chat.isOnline),
            CustomSizes.smallSizedBoxWidth,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        chat.name,
                        style: TEXTSTYLES.kButtonBasic.copyWith(
                          color: COLORS.kWhiteColor,
                          height: 1,
                        ),
                      ),
                      SizedBox(width: 5.w),
                      if (chat.isVerified)
                        Assets.svg.verified.svg(
                          width: 12.w,
                          height: 12.w,
                          color: COLORS.kWhiteColor,
                        ),
                    ],
                  ),
                ),
                if (chat.isOnline)
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
                        size: 12,
                        color: COLORS.kWhiteColor,
                      ),
                      SizedBox(width: 4.w),
                      Assets.svg.lunaConnection.svg(
                        width: 10.w,
                        height: 10.w,
                      ),
                    ],
                  ),
              ],
            ),
            Spacer(),
            Row(
              children: [
                Assets.svg.videoCallIcon.svg(),
                SizedBox(width: 24.w),
                Assets.svg.audioCallIcon.svg(),
                SizedBox(width: 24.w),
                Assets.svg.verticalMenuIcon.svg(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}
