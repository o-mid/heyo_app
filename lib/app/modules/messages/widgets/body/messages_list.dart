import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/controllers/messages_controller.dart';

import 'beginning_of_messages_header_widget.dart';
import 'message_item_widget.dart';

class MessagesList extends StatelessWidget {
  const MessagesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MessagesController>();

    return GestureDetector(
      // when the media Media Glassmorphic is Open tap on the rest of the screen will close it
      onTap: () => controller.closeMediaGlassmorphic(),

      child: Obx(() {
        return ListView.builder(
          primary: false,
          controller: controller.scrollController,
          shrinkWrap: true,
          reverse: true,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
          padding: EdgeInsets.only(top: 54.h, bottom: 16.h),
          itemCount: controller.messages.length + 1,
          itemBuilder: (context, index) {
            // reverse index
            final reverseIndex = controller.messages.length - index;
            if (reverseIndex == 0) {
              return const BeginningOfMessagesHeaderWidget();
            } else {
              return MessageItemWidget(index: reverseIndex - 1);
            }
          },
        );
      }),
    );
  }
}
