import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/chats/data/models/chat_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/fonts.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/widgets/curtom_circle_avatar.dart';
import 'package:heyo/app/modules/shared/widgets/notification_count_badge.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:intl/intl.dart';
import 'package:heyo/app/modules/shared/utils/extensions/date.extension.dart';
import 'package:swipeable_tile/swipeable_tile.dart';

import '../../../../generated/locales.g.dart';
import '../controllers/chats_controller.dart';

class ChatWidget extends GetView<ChatsController> {
  final ChatModel chat;
  const ChatWidget({Key? key, required this.chat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SwipeableTile.swipeToTrigger(
      key: Key(chat.id),
      isElevated: false,
      swipeThreshold: 0.21,
      borderRadius: 0,
      onSwiped: (SwipeDirection direction) {
        controller.showDeleteChatDialog(chat);
      },
      color: COLORS.kAppBackground,
      backgroundBuilder:
          (BuildContext context, SwipeDirection direction, AnimationController progress) {
        return Container(
          alignment: Alignment.centerRight,
          color: COLORS.kStatesErrorColor,
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Assets.svg.deleteIcon.svg(
            color: COLORS.kWhiteColor,
            width: 18.w,
            height: 18.w,
          ),
        );
      },
      child: Row(
        children: [
          CustomCircleAvatar(
            url: chat.icon,
            size: 48,
            isOnline: chat.isOnline,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          chat.name,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontFamily: FONTS.interFamily,
                            fontWeight: chat.notificationCount > 0 ? FONTS.Bold : FONTS.Medium,
                          ),
                        ),
                        const SizedBox(width: 6),
                        if (chat.isVerified)
                          Assets.svg.verified.svg(
                            width: 12.w,
                            height: 12.w,
                          ),
                      ],
                    ),
                    Text(
                      DateHelpers(chat.timestamp).isToday()
                          ? DateFormat.Hm().format(chat.timestamp)
                          : DateHelpers(chat.timestamp).isYesterday()
                              ? LocaleKeys.yesterday.tr
                              : DateFormat('d/m/yy').format(chat.timestamp),
                      style: TextStyle(
                        fontFamily: FONTS.interFamily,
                        fontWeight: FONTS.Medium,
                        fontSize: 10.sp,
                        color: COLORS.kTextSoftBlueColor,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        chat.lastMessage,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TEXTSTYLES.kBodySmall.copyWith(
                          color: chat.notificationCount > 0
                              ? COLORS.kDarkBlueColor
                              : COLORS.kTextSoftBlueColor,
                          fontWeight: chat.notificationCount > 0 ? FONTS.SemiBold : null,
                        ),
                      ),
                    ),
                    if (chat.notificationCount > 0)
                      Container(
                        margin: EdgeInsets.only(left: 8.w),
                        child: NotificationCountBadge(
                          backgroundColor: COLORS.kGreenMainColor,
                          count: chat.notificationCount,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
