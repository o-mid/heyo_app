import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/controllers/messages_controller.dart';
import 'package:heyo/app/modules/messages/data/models/messages/message_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/extensions/datetime.extension.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'beginning_of_messages_header_widget.dart';
import 'message_selection_wrapper.dart';
import 'message_item_widget.dart';

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
        child: controller.messages.isEmpty
            ? const CircularProgressIndicator.adaptive(
                valueColor: AlwaysStoppedAnimation<Color>(COLORS.kGreenMainColor),
              )
            : ListView.builder(
                primary: false,
                controller: controller.scrollController,
                padding: EdgeInsets.only(top: 54.h, bottom: 16.h),
                itemCount: controller.messages.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return const BeginningOfMessagesHeaderWidget();
                  } else {
                    final message = controller.messages[index - 1];

                    return MessageItemWidget(index: index, message: message);
                  }
                }),
      );
    });
  }
}
