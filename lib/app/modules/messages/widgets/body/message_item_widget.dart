import 'dart:ffi';

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
    Key? key,
    required this.index,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MessagesController>();
    final message = controller.messages[index];
    final prevMessage = (index > 0) ? controller.messages[index - 1] : null;

    return VisibilityDetector(
      key: Key(message.messageId),
      onVisibilityChanged: (info) => controller.onMessagesItemVisibilityChanged(
          visibilityInfo: info,
          itemIndex: index,
          itemMessageId: message.messageId,
          itemStatus: message.status,
          isFromMe: message.isFromMe),
      child: _buildMessageBody(controller, message, prevMessage),
    );
  }

  Widget _buildMessageBody(
      MessagesController controller, MessageModel message, MessageModel? prevMessage) {
    return AutoScrollTag(
      key: Key(message.messageId),
      index: index,
      controller: controller.scrollController,
      child: Column(
        children: [
          _buildDateHeader(message, prevMessage),
          MessageSelectionWrapper(
            message: message,
          ),
        ],
      ),
    );
  }

  Widget _buildDateHeader(MessageModel message, MessageModel? prevMessage) {
    if (prevMessage == null || !prevMessage.timestamp.isSameDate(message.timestamp)) {
      return MessagesDateHeaderWidget(
        headerValue: message.timestamp.differenceFromNow(),
      );
    }
    return const SizedBox();
  }
}
