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

    return Obx(() {
      return GestureDetector(
        // when the media Media Glassmorphic is Open tap on the rest of the screen will close it
        onTap: () => controller.closeMediaGlassmorphic(),
        child: ListView.custom(
          primary: false,
          controller: controller.scrollController,
          reverse: true,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
          padding: EdgeInsets.only(top: 54.h, bottom: 16.h),
          childrenDelegate: SliverChildBuilderDelegate(
            (context, index) {
              // reverse index
              final reverseIndex = controller.messages.length - index;
              if (reverseIndex == 0) {
                return const BeginningOfMessagesHeaderWidget();
              } else {
                // added a key ( item messageId) to the widget to be able to find it later

                return MessageItemWidget(
                    key: ValueKey(controller.messages[reverseIndex - 1].messageId),
                    index: reverseIndex - 1);
              }
            },
            childCount: controller.messages.length + 1,
            addRepaintBoundaries: false,
            addAutomaticKeepAlives: true,
            //  find the new index of a child
            findChildIndexCallback: (key) {
              // get the index of the message from the key

              final valueKey = key as ValueKey<String>;

              final msgIndex =
                  controller.messages.indexWhere((element) => element.messageId == valueKey.value);

              return controller.messages.length - msgIndex - 1;
            },
          ),
        ),
      );
    });
  }
}
