import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/controllers/messages_controller.dart';
import 'package:heyo/app/modules/messages/data/models/message_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';

import 'message_from_me_widget.dart';
import 'message_from_other_widget.dart';

class MessageSelectionWrapper extends StatefulWidget {
  final MessageModel message;
  const MessageSelectionWrapper({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  State<MessageSelectionWrapper> createState() => _MessageSelectionWrapperState();
}

class _MessageSelectionWrapperState extends State<MessageSelectionWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    final message = widget.message;
    final controller = Get.find<MessagesController>();

    return GestureDetector(
      key: Key(message.messageId),
      onLongPress: () => controller.toggleMessageSelection(message.messageId),
      onTap: controller.selectedMessages.isEmpty
          ? null
          : () => controller.toggleMessageSelection(message.messageId),
      child: Stack(
        children: [
          // Material is used because if container is given color, it will
          // hide the reaction widget borders
          Material(
            color: message.isSelected ? COLORS.kGreenLighterColor : Colors.transparent,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 4.h),
              child: message.isFromMe
                  ? MessageFromMeWidget(message: message)
                  : MessageFromOtherWidget(
                      message: message,
                      showTimeAndProfile: true,
                      // showTimeAndProfile: index == controller.messages.length - 1 ||
                      //     controller.messages[index + 1].senderName != message.senderName,
                    ),
            ),
          ),
          if (message.isSelected)
            Positioned(
              top: 0,
              bottom: 0,
              child: Container(
                color: COLORS.kGreenMainColor,
                width: 3,
              ),
            )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => widget.message.type == CONTENT_TYPE.VIDEO;
}
