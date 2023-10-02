import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/controllers/messages_controller.dart';
import 'package:heyo/app/modules/messages/data/models/messages/message_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/extensions/datetime.extension.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';

import 'package:visibility_detector/visibility_detector.dart';

import '../../../shared/utils/scroll_to_index.dart';
import 'message_date_header_widget.dart';
import 'message_selection_wrapper.dart';

class MessageItemWidget extends StatelessWidget {
  const MessageItemWidget({
    super.key,
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MessagesController>();

    final prevMessage = index < 1 ? null : controller.messages[index - 1];

    final MessageModel message = controller.messages[index];

    // Adds date header at beginning of new messages in a certain date
    Widget dateHeader() {
      if (prevMessage == null || !prevMessage.timestamp.isSameDate(message.timestamp)) {
        return MessagesDateHeaderWidget(
          headerValue: message.timestamp.differenceFromNow(),
        );
      } else {
        return const SizedBox();
      }
    }

    Widget messageBody = AutoScrollTag(
      key: Key(message.messageId),
      index: index,
      controller: controller.scrollController,
      child: Column(
        children: [
          dateHeader(),
          MessageSelectionWrapper(
            message: message,
            iconUrl: controller.user.value.iconUrl,
          ),
        ],
      ),
    );

    return VisibilityDetector(
        key: Key(message.messageId),
        onVisibilityChanged: (info) => controller.onMessagesItemVisibilityChanged(
            visibilityInfo: info,
            itemIndex: index,
            itemMessageId: message.messageId,
            itemStatus: message.status,
            isFromMe: message.isFromMe),
        child: messageBody);
  }
}
