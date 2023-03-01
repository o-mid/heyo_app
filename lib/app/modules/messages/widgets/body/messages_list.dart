import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/controllers/messages_controller.dart';
import 'package:heyo/app/modules/messages/data/models/messages/message_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/extensions/datetime.extension.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';

import '../../../shared/utils/scroll_to_index.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'beginning_of_messages_header_widget.dart';
import 'message_selection_wrapper.dart';
import 'message_item_widget.dart';

class MessagesList extends StatelessWidget {
  const MessagesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MessagesController>();

    // when the media Media Glassmorphic is Open tap on the rest of the screen will close it
    return Obx(() {
      return GestureDetector(
        onTap: () {
          print(controller.isMediaGlassmorphicOpen);
          if (controller.isMediaGlassmorphicOpen.value) {
            controller.isMediaGlassmorphicOpen.value = false;
          }
        },
        child: ListView.custom(
          primary: false,
          controller: controller.scrollController,
          reverse: true,
          padding: EdgeInsets.only(top: 54.h, bottom: 16.h),
          // itemCount: controller.messages.length + 1,
          // itemBuilder: (context, index) {
          //   if (index == 0) {
          //     return const BeginningOfMessagesHeaderWidget();
          //   } else {
          //     return MessageItemWidget(index: index - 1);
          //   }
          // },

          childrenDelegate: SliverChildBuilderDelegate(
            (context, index) {
              // reverse index
              final reverseIndex = controller.messages.length - index;
              if (reverseIndex == 0) {
                return const BeginningOfMessagesHeaderWidget();
              } else {
                return MessageItemWidget(
                    key: ValueKey(controller.messages[reverseIndex - 1].messageId),
                    index: reverseIndex - 1);
              }
            },

            childCount: controller.messages.length + 1,
            // addRepaintBoundaries: false,
            // addAutomaticKeepAlives: false,
            findChildIndexCallback: (key) {
              final valueKey = key as ValueKey<String>;

              final val =
                  controller.messages.indexWhere((element) => element.messageId == valueKey.value);
              return controller.messages.length - val - 1;
            },
          ),
        ),
      );
    });
  }
}
