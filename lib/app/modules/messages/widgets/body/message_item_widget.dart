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

import 'message_selection_wrapper.dart';

class MessageItemWidget extends StatelessWidget {
  const MessageItemWidget({
    super.key,
    required this.message,
    required this.index,
  });

  final MessageModel message;
  final int index;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MessagesController>();

    final prevMessage = index == 1 ? null : controller.messages[index - 2];

    // Adds date header at beginning of new messages in a certain date
    List<Widget> dateHeaderWidgets = <Widget>[];
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
    Widget messageBody = AutoScrollTag(
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

    // if the message is from me, don't wrap it in a VisibilityDetector
    if (message.isFromMe) {
      return messageBody;
    } else {
      return VisibilityDetector(
          key: Key(message.messageId),
          onVisibilityChanged: (info) => controller.onRemoteMessagesItemVisibilityChanged(
              visibilityInfo: info,
              itemIndex: index,
              itemMessageId: message.messageId,
              itemStatus: message.status),
          child: messageBody);
    }
  }
}
