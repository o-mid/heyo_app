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

            // The two following widgets are to show a green online badge on chat icon
            // and a white border around the green badge. It could be done with only one
            // Container with a border, but this also creates a thin outer border after the white
            // one which is not desirable. As a solution this is used for now
            if (chat.isOnline)
              Positioned(
                bottom: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: COLORS.kWhiteColor,
                    ),
                  ),
                ),
              ),
            if (chat.isOnline)
              Positioned(
                bottom: 2,
                right: 2,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: COLORS.kStatesLightSuccessColor,
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
