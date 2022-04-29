import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heyo/app/modules/messages/data/models/messages/audio_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/image_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/text_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/video_message_model.dart';
import 'package:heyo/app/modules/messages/widgets/body/reactions_widget.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/messages/widgets/body/audio_message_player_widget.dart';
import 'package:heyo/app/modules/messages/widgets/body/video_message_player.dart';

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

    switch (message.runtimeType) {
      case TextMessageModel:
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            (message as TextMessageModel).text,
            style: TEXTSTYLES.kChatText.copyWith(color: textColor),
          ),
        );
      case ImageMessageModel:
        return ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: ExtendedImage.network(
            (message as ImageMessageModel).url,
          ),
        );
      case VideoMessageModel:
        return VideoMessagePlayer(
          message: message as VideoMessageModel,
        );
      case AudioMessageModel:
        return AudioMessagePlayer(
          message: message as AudioMessageModel,
          backgroundColor: backgroundColor,
          textColor: message.isFromMe ? COLORS.kWhiteColor : COLORS.kDarkBlueColor,
          iconColor: message.isFromMe ? COLORS.kWhiteColor : COLORS.kGreenMainColor,
          activeSliderColor: message.isFromMe ? COLORS.kWhiteColor : COLORS.kGreenMainColor,
          inactiveSliderColor: message.isFromMe
              ? COLORS.kWhiteColor.withOpacity(0.2)
              : COLORS.kDarkBlueColor.withOpacity(0.2),
        );
      default:
        return SizedBox.shrink();
    }
  }
}
