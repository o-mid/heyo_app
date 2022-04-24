import 'package:better_player/better_player.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heyo/app/modules/messages/data/models/message_model.dart';
import 'package:heyo/app/modules/messages/widgets/reactions_widget.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';

class MessageBodyWidget extends StatelessWidget {
  final MessageModel message;
  final Color backgroundColor;
  final Color textColor;
  const MessageBodyWidget({
    Key? key,
    required this.message,
    required this.backgroundColor,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomSizes.mediumSizedBoxWidth,
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 4.h),
                child: _MessageContent(
                  message: message,
                  backgroundColor: backgroundColor,
                  textColor: textColor,
                ),
              ),
              if (message.reactions.isNotEmpty) ReactionsWidget(message: message),
            ],
          ),
        ),
        Spacer(),
      ],
    );
  }
}

class _MessageContent extends StatelessWidget {
  final MessageModel message;
  final Color backgroundColor;
  final Color textColor;
  const _MessageContent({
    Key? key,
    required this.message,
    required this.backgroundColor,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (message.type) {
      case CONTENT_TYPE.TEXT:
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            message.payload,
            style: TEXTSTYLES.kChatText.copyWith(color: textColor),
          ),
        );
      case CONTENT_TYPE.IMAGE:
        return ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: ExtendedImage.network(
            message.payload,
            borderRadius: BorderRadius.circular(8.r),
          ),
        );
      case CONTENT_TYPE.VIDEO:
        return BetterPlayer.network(
          message.payload,
        );
    }
  }
}
