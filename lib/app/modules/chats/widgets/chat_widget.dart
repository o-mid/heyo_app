import 'package:flutter/material.dart';
import 'package:heyo/app/modules/chats/data/models/chat_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/fonts.dart';
import 'package:heyo/app/modules/shared/utils/widgets/notification_count_badge.dart';
import 'package:heyo/generated/assets.gen.dart';

class ChatWidget extends StatelessWidget {
  final ChatModel chat;
  const ChatWidget({Key? key, required this.chat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Stack(
          children: [
            Container(
              width: 48,
              height: 48,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  chat.icon,
                ),
              ),
            ),
            // Todo: fix the problem with outer border
            if (chat.isOnline)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: COLORS.kStatesLightSuccessColor,
                    border: Border.all(
                      width: 2,
                      color: COLORS.kWhiteColor,
                    ),
                  ),
                ),
              ),
          ],
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
                          fontFamily: FONTS.interFamily,
                          fontWeight: FONTS.Medium,
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
                      style: TextStyle(
                        fontFamily: FONTS.interFamily,
                        fontSize: 13,
                        color: COLORS.kTextSoftBlueColor,
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
