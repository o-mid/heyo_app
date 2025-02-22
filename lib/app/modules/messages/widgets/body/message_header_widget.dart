import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/data/models/messages/message_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/fonts.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/extensions/core_id.extension.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';

class MessageHeaderWidget extends StatelessWidget {
  final MessageModel message;
  final bool isMockMessage;
  final bool isGroupChat;
  const MessageHeaderWidget(
      {Key? key, required this.message, this.isMockMessage = false, required this.isGroupChat})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: message.isFromMe ? TextDirection.rtl : TextDirection.ltr,
      children: [
        CustomSizes.mediumSizedBoxWidth,
        if (!isMockMessage)
          Row(
            children: [
              if (isGroupChat)
                Text(
                  message.senderName.isNotEmpty && message.senderName.isNotEmpty != "Unknown"
                      ? '${message.senderName} . '
                      : '${message.senderAvatar.shortenCoreId} . ',
                  textAlign: TextAlign.center,
                  style: TEXTSTYLES.kBodyTag.copyWith(
                    color: COLORS.kTextBlueColor,
                    fontSize: 10.sp,
                  ),
                ),
              Text(
                "${message.timestamp.hour.toString().padLeft(2, '0')}:${message.timestamp.minute.toString().padLeft(2, '0')}",
                style: TEXTSTYLES.kBodyTag.copyWith(
                  color: COLORS.kTextBlueColor,
                  fontSize: 10.sp,
                ),
              ),
            ],
          )
        else
          Text(
            "00:00",
            style: TEXTSTYLES.kBodyTag.copyWith(
              color: COLORS.kTextBlueColor,
              fontSize: 10.sp,
            ),
          ),

        /// Status Indicator
        if (message.isFromMe) ...[
          SizedBox(width: 4.w),
          messageStatusIconWidget(),
        ],

        /// Forwarded Indicator
        if (message.isForwarded) ...[
          SizedBox(width: 5.w),
          Container(
            width: 2.w,
            height: 2.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: COLORS.kDarkBlueColor,
            ),
          ),
          SizedBox(width: 5.w),
          Text(
            LocaleKeys.MessagesPage_forwarded.tr,
            style: TEXTSTYLES.kReactionNumber.copyWith(
              fontWeight: FONTS.Medium,
              color: COLORS.kTextBlueColor,
            ),
          ),
          SizedBox(width: 5.w),
          Assets.svg.replyFilledMirror.svg(),
        ],
      ],
    );
  }

  SvgPicture messageStatusIconWidget() {
    switch (message.status) {
      case MessageStatus.sending:
        return Assets.svg.clock.svg(
          width: 10.w,
          height: 10.w,
        );

      case MessageStatus.sent:
        return Assets.svg.singleTickIcon.svg(
          width: 8.w,
          height: 8.w,
        );
      case MessageStatus.delivered:
        return Assets.svg.doubleTickIcon.svg(
          width: 12.w,
          height: 8.w,
          color: COLORS.kTextBlueColor,
        );
      case MessageStatus.read:
        return Assets.svg.doubleTickIcon.svg(
          width: 12.w,
          height: 8.w,
        );

      case MessageStatus.failed:
        return Assets.svg.failedIcon.svg(
          height: 13.w,
          color: COLORS.kStatesErrorColor,
        );
    }
  }
}
