import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/controllers/messages_controller.dart';
import 'package:heyo/app/modules/messages/widgets/body/MessagesLoadingWidget.dart';
import 'package:heyo/app/modules/messages/widgets/body/beginning_of_messages_header_widget.dart';
import 'package:heyo/app/modules/messages/widgets/body/message_item_widget.dart';

class MessagesListViewWidget extends StatelessWidget {
  const MessagesListViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MessagesController>();
    return Obx(() {
      if (!controller.isListLoaded.value) {
        return const Center(child: MessagesLoadingWidget());
      } else {
        return ListView.builder(
          primary: false,
          controller: controller.scrollController,
          shrinkWrap: true,
          reverse: true,
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
        );
      }
    });
  }
}
