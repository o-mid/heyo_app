import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/controllers/messages_controller.dart';
import 'package:heyo/app/modules/messages/data/models/message_model.dart';
import 'package:heyo/app/modules/messages/widgets/recipient_reply_to_widget.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/widgets/curtom_circle_avatar.dart';

import 'message_body_widget.dart';

class MessageFromOtherWidget extends StatelessWidget {
  final MessageModel message;
  final bool showTimeAndProfile;
  const MessageFromOtherWidget({Key? key, required this.message, this.showTimeAndProfile = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomSizes.mediumSizedBoxWidth,
        if (showTimeAndProfile) CustomCircleAvatar(url: message.senderAvatar, size: 20),
        if (!showTimeAndProfile) SizedBox(width: 20.w),
        Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  CustomSizes.mediumSizedBoxWidth,
                  if (showTimeAndProfile)
                    Text(
                      "${message.timestamp.hour.toString().padLeft(2, '0')}:${message.timestamp.minute.toString().padLeft(2, '0')}",
                      style: TEXTSTYLES.kBodyTag.copyWith(
                        color: COLORS.kTextBlueColor,
                        fontSize: 10.sp,
                      ),
                    ),
                ],
              ),
              SizedBox(height: 4.h),
              if (message.replyTo != null)
                GestureDetector(
                  onTap: () {
                    Get.find<MessagesController>()
                        .scrollToMessage(message.replyTo!.repliedToMessageId);
                  },
                  child: RecipientReplyTo(
                    message: message,
                  ),
                ),
              MessageBodyWidget(
                message: message,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
