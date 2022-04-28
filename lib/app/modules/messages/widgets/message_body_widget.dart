import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heyo/app/modules/messages/data/models/message_model.dart';
import 'package:heyo/app/modules/messages/widgets/reactions_widget.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/messages/widgets/audio_message_player_widget.dart';
import 'package:heyo/app/modules/shared/widgets/video_message_player.dart';

class MessageBodyWidget extends StatelessWidget {
  final MessageModel message;
  const MessageBodyWidget({
    Key? key,
    required this.message,
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
                ),
              ),
              if (message.reactions.isNotEmpty) ReactionsWidget(message: message),
            ],
          ),
        ),
        const Spacer(),
      ],
    );
  }
}

class _MessageContent extends StatelessWidget {
  final MessageModel message;
  const _MessageContent({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        message.isFromMe ? COLORS.kGreenMainColor : COLORS.kPinCodeDeactivateColor;
    final textColor = message.isFromMe ? COLORS.kWhiteColor : COLORS.kDarkBlueColor;

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
          ),
        );
      case CONTENT_TYPE.VIDEO:
        return VideoMessagePlayer(
          message: message,
        );
      case CONTENT_TYPE.AUDIO:
        return AudioMessagePlayer(
          message: message,
          backgroundColor: backgroundColor,
          textColor: message.isFromMe ? COLORS.kWhiteColor : COLORS.kDarkBlueColor,
          iconColor: message.isFromMe ? COLORS.kWhiteColor : COLORS.kGreenMainColor,
          activeSliderColor: message.isFromMe ? COLORS.kWhiteColor : COLORS.kGreenMainColor,
          inactiveSliderColor: message.isFromMe
              ? COLORS.kWhiteColor.withOpacity(0.2)
              : COLORS.kDarkBlueColor.withOpacity(0.2),
        );
    }
  }
}
