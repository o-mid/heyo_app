import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/controllers/messages_controller.dart';
import 'package:heyo/app/modules/messages/data/models/messages/audio_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/live_location_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/location_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/video_message_model.dart';
import 'package:heyo/app/modules/messages/widgets/body/sender_reply_to_widget.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';

import 'message_widget.dart';
import 'reaction_box.dart';
import 'recipient_reply_to_widget.dart';

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

    return Column(
      children: [
        if (message.replyTo != null)
          Row(
            textDirection: message.isFromMe ? TextDirection.rtl : TextDirection.ltr,
            children: [
              if (!message.isFromMe) SizedBox(width: 16.w + 20), // Left padding + profile size
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Get.find<MessagesController>().scrollToMessage(
                      messageId: message.replyTo!.repliedToMessageId,
                    );
                  },
                  child: message.isFromMe
                      ? SenderReplyToWidget(message: message)
                      : RecipientReplyTo(
                          message: message,
                        ),
                ),
              ),
            ],
          ),
        GestureDetector(
          key: Key(message.messageId),
          onLongPress: () => controller.toggleMessageSelection(message.messageId),
          onTap: controller.selectedMessages.isEmpty
              ? null
              : () => controller.toggleMessageSelection(message.messageId),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              // Material is used because if container is given color, it will
              // hide the reaction widget borders
              Material(
                color: message.isSelected ? COLORS.kGreenLighterColor : Colors.transparent,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: MessageWidget(
                    message: message,
                    // showTimeAndProfile: index == controller.messages.length - 1 ||
                    //     controller.messages[index + 1].senderName != message.senderName,
                  ),
                ),
              ),
              // Todo: optimize if necessary
              Positioned(
                top: -4.h,
                child: AnimatedScale(
                  scale: message.isSelected && controller.selectedMessages.length == 1 ? 1 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: ReactionBox(
                    message: message,
                  ),
                ),
              ),
              if (message.isSelected)
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  child: Container(
                    color: COLORS.kGreenMainColor,
                    width: 3,
                  ),
                )
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive =>
      widget.message is VideoMessageModel ||
      widget.message is AudioMessageModel ||
      widget.message is LiveLocationMessageModel ||
      widget.message is LocationMessageModel;
}
