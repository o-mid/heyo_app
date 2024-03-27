import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/data/models/messaging_participant_model.dart';

import 'package:heyo/app/modules/shared/widgets/slidable_widget.dart';
import 'package:heyo/modules/features/chats/presentation/controllers/chats_controller.dart';
import 'package:heyo/app/modules/chats/data/models/chat_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/fonts.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/widgets/curtom_circle_avatar.dart';
import 'package:heyo/app/modules/shared/widgets/notification_count_badge.dart';
import 'package:heyo/app/modules/shared/utils/extensions/date.extension.dart';
import 'package:heyo/app/modules/shared/data/models/messages_view_arguments_model.dart';
import 'package:heyo/app/routes/app_pages.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';
import 'package:intl/intl.dart';

import '../../shared/widgets/stacked_avatars_widget.dart';

class ChatWidget extends GetView<ChatsController> {
  final String chatId;
  final String name;
  final String lastMessage;
  final DateTime timestamp;
  final List<MessagingParticipantModel> participants;
  final int notificationCount;
  final bool isGroupChat;

  const ChatWidget({
    Key? key,
    required this.chatId,
    required this.name,
    required this.lastMessage,
    required this.timestamp,
    required this.participants,
    this.notificationCount = 0,
    this.isGroupChat = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final isGroupChat = participants.length > 2;
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
      child: SlidableWidget(
        key: Key(chatId),
        onDismissed: () => controller.deleteChat(chatId),
        confirmDismiss: () => controller.showDeleteChatDialog(chatId),
        child: InkWell(
          onTap: () {
            Get.toNamed(
              Routes.MESSAGES,
              arguments: MessagesViewArgumentsModel(
                participants: participants,
                chatName: name,
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isGroupChat)
                  StackedAvatars(
                    avatarSize: 24,
                    coreId1: participants.first.coreId,
                    coreId2: participants.last.coreId,
                  )
                else
                  CustomCircleAvatar(
                    coreId: participants.first.coreId,
                    size: 48,
                    isOnline: true,
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
                                name,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontFamily: FONTS.interFamily,
                                  fontWeight: notificationCount > 0 ? FONTS.Bold : FONTS.Medium,
                                ),
                              ),
                              const SizedBox(width: 6),
                              // if (isVerified)
                              //   Assets.svg.verified.svg(
                              //     width: 12.w,
                              //     height: 12.w,
                              //   ),
                            ],
                          ),
                          Text(
                            DateHelpers(timestamp).isToday()
                                ? DateFormat.Hm().format(timestamp)
                                : DateHelpers(timestamp).isYesterday()
                                    ? LocaleKeys.yesterday.tr
                                    : DateFormat('d/m/yy').format(timestamp),
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
                              lastMessage,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TEXTSTYLES.kBodySmall.copyWith(
                                color: notificationCount > 0
                                    ? COLORS.kDarkBlueColor
                                    : COLORS.kTextSoftBlueColor,
                                fontWeight: notificationCount > 0 ? FONTS.SemiBold : null,
                              ),
                            ),
                          ),
                          if (notificationCount > 0)
                            Container(
                              margin: EdgeInsets.only(left: 8.w),
                              child: NotificationCountBadge(
                                backgroundColor: COLORS.kGreenMainColor,
                                count: notificationCount,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
