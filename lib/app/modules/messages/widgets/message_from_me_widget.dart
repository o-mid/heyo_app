import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/controllers/messages_controller.dart';
import 'package:heyo/app/modules/messages/data/models/message_model.dart';
import 'package:heyo/app/modules/messages/widgets/sender_reply_to_widget.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/generated/assets.gen.dart';

import 'message_body_widget.dart';

class MessageFromMeWidget extends StatelessWidget {
  final MessageModel message;
  const MessageFromMeWidget({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          if (message.replyTo != null)
            GestureDetector(
              onTap: () {
                Get.find<MessagesController>().scrollToMessage(message.replyTo!.repliedToMessageId);
              },
              child: SenderReplyToWidget(replyTo: message.replyTo!),
            ),
          Row(
            children: [
              CustomSizes.mediumSizedBoxWidth,
              Text(
                "${message.timestamp.hour.toString().padLeft(2, '0')}:${message.timestamp.minute.toString().padLeft(2, '0')}",
                style: TEXTSTYLES.kBodyTag.copyWith(
                  color: COLORS.kTextBlueColor,
                  fontSize: 10.sp,
                ),
              ),
              SizedBox(width: 4.w),
              if (message.status == MESSAGE_STATUS.READ)
                Assets.svg.doubleTickIcon.svg(
                  width: 12.w,
                  height: 8.w,
                ),
              if (message.status == MESSAGE_STATUS.SENT)
                Assets.svg.singleTickIcon.svg(
                  width: 8.w,
                  height: 8.w,
                ),
            ],
          ),
          SizedBox(height: 4.h),
          MessageBodyWidget(
            backgroundColor: COLORS.kGreenMainColor,
            textColor: COLORS.kWhiteColor,
            message: message,
          ),
        ],
      ),
    );
  }
}
