import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/controllers/messages_controller.dart';

import '../../data/models/messages/message_model.dart';
import '../../utils/messages_list_scroll_physics.dart';
import 'MessagesLoadingWidget.dart';
import 'beginning_of_messages_header_widget.dart';
import 'message_item_widget.dart';

class MessagesListViewWidget extends StatelessWidget {
  const MessagesListViewWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MessagesController>();
    return Obx(() {
      return Stack(
        children: [
          // show loading widget if list is not loaded and scrolled to the saved state

          controller.isListLoaded.value
              ? const SizedBox.shrink()
              : const Center(child: MessagesLoadingWidget()),

          // show list of messages after list is loaded
          Opacity(
            opacity: controller.isListLoaded.value ? 1 : 0,
            child: ListView.builder(
              primary: false,
              controller: controller.scrollController,
              shrinkWrap: true,
              // change the isFastScroll property if the scroll is slower than expected
              physics: const MessagesListScrollPhysics(
                isFastScroll: false,
              ),
              reverse: true,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
              padding: EdgeInsets.only(top: 54.h, bottom: 16.h),
              itemCount: controller.messages.length + 1,
              itemBuilder: (context, index) {
                // reverse index
                final reverseIndex = controller.messages.length - index;
                if (reverseIndex == 0) {
                  return BeginningOfMessagesHeaderWidget(
                    iconUrl: controller.user.value.iconUrl,
                    userName: controller.user.value.name,
                  );
                } else {
                  return MessageItemWidget(index: reverseIndex - 1);
                }
              },
            ),
          ),
        ],
      );
    });
  }
}
