import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/controllers/messages_controller.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/extensions/datetime.extension.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import 'beginning_of_messages_header.dart';
import 'message_selection_wrapper.dart';

class MessagesList extends StatelessWidget {
  const MessagesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MessagesController>();
    return Obx(() {
      // when the media Media Glassmorphic is Open tap on the rest of the screen will close it
      return GestureDetector(
        onTap: () {
          if (controller.isMediaGlassmorphicOpen.value) {
            controller.isMediaGlassmorphicOpen.value = false;
          }
        },
        child: ListView.builder(
          controller: controller.scrollController,
          padding: EdgeInsets.only(top: 54.h, bottom: 16.h),
          itemCount: controller.messages.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return BeginningOfMessagesHeader(
                chat: controller.args.user.chatModel,
              );
            }

            final message = controller.messages[index - 1];
            final prevMessage = index == 1 ? null : controller.messages[index - 2];

            // Adds date header at beginning of new messages in a certain date
            var dateHeaderWidgets = <Widget>[];
            if (prevMessage == null || !prevMessage.timestamp.isSameDate(message.timestamp)) {
              dateHeaderWidgets = [
                CustomSizes.mediumSizedBoxHeight,
                Text(
                  message.timestamp.differenceFromNow(),
                  style: TEXTSTYLES.kBodyTag.copyWith(
                    color: COLORS.kTextBlueColor,
                    fontSize: 10.sp,
                  ),
                ),
                CustomSizes.mediumSizedBoxHeight,
              ];
            }

            return AutoScrollTag(
              key: Key(index.toString()),
              index: index,
              controller: controller.scrollController,
              child: Column(
                children: [
                  ...dateHeaderWidgets,
                  MessageSelectionWrapper(
                    message: message,
                  ),
                ],
              ),
            );
          },
        ),
      );
    });
  }
}
