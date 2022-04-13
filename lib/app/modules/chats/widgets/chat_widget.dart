import 'package:flutter/material.dart';
import 'package:heyo/app/modules/chats/data/models/chat_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/fonts.dart';

class ChatWidget extends StatelessWidget {
  final ChatModel chat;
  const ChatWidget({Key? key, required this.chat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          child: Image.network(
            chat.icon,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    chat.name,
                    style: TextStyle(
                      fontFamily: FONTS.interFamily,
                      fontWeight: FONTS.Medium,
                    ),
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
                      alignment: Alignment.center,
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: COLORS.kGreenMainColor,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        chat.notificationCount > 9 ? '9+' : chat.notificationCount.toString(),
                        style: TextStyle(
                          color: COLORS.kWhiteColor,
                          fontSize: 8,
                          fontFamily: FONTS.interFamily,
                        ),
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
