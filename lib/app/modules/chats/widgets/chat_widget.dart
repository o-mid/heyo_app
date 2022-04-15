import 'package:flutter/material.dart';
import 'package:heyo/app/modules/chats/data/models/chat_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/fonts.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/widgets/curtom_circle_avatar.dart';
import 'package:heyo/app/modules/shared/utils/widgets/notification_count_badge.dart';
import 'package:heyo/generated/assets.gen.dart';

class ChatWidget extends StatelessWidget {
  final ChatModel chat;
  const ChatWidget({Key? key, required this.chat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomCircleAvatar(
          url: chat.icon,
          size: 48,
          isOnline: chat.isOnline,
        ),
        SizedBox(width: 16),
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
                          fontSize: 14,
                          fontFamily: FONTS.interFamily,
                          fontWeight: chat.notificationCount > 0 ? FONTS.Bold : FONTS.Medium,
                        ),
                      ),
                      SizedBox(width: 6),
                      if (chat.isVerified) Assets.svg.verified.svg(),
                    ],
                  ),
                  Text(
                    chat.timestamp,
                    style: TextStyle(
                      fontFamily: FONTS.interFamily,
                      fontWeight: FONTS.Medium,
                      fontSize: 10,
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
                      margin: EdgeInsets.only(left: 8),
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
    );
  }
}
