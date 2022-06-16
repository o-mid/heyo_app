import 'dart:io';
import 'dart:math';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heyo/app/modules/messages/data/models/messages/audio_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/call_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/image_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/live_location_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/location_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/multi_media_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/text_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/video_message_model.dart';
import 'package:heyo/app/modules/messages/widgets/body/call_message_widget.dart';
import 'package:heyo/app/modules/messages/widgets/body/file_message_widget.dart';
import 'package:heyo/app/modules/messages/widgets/body/location/location_message_widget.dart';
import 'package:heyo/app/modules/messages/widgets/body/multi_media_message_widget.dart';
import 'package:heyo/app/modules/messages/widgets/body/reactions_widget.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/messages/widgets/body/audio_message_player_widget.dart';
import 'package:heyo/app/modules/messages/widgets/body/video_message_player.dart';

import '../../data/models/messages/file_message_model.dart';
import 'location/live_location_message_widget.dart';

class MessageBodyWidget extends StatelessWidget {
  final MessageModel message;
  const MessageBodyWidget({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: message.isFromMe ? TextDirection.rtl : TextDirection.ltr,
      child: Row(
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
                if (message.reactions.isNotEmpty)
                  ReactionsWidget(message: message),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
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
    final backgroundColor = message.isFromMe
        ? COLORS.kGreenMainColor
        : COLORS.kPinCodeDeactivateColor;
    final textColor =
        message.isFromMe ? COLORS.kWhiteColor : COLORS.kDarkBlueColor;

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
        return LayoutBuilder(builder: (context, constraints) {
          final mWidth = (message as ImageMessageModel).metadata.width;
          final mHeight = (message as ImageMessageModel).metadata.height;
          final width = min(mWidth, constraints.maxWidth);
          final height = width * (mHeight / mWidth);
          return SizedBox(
            width: width,
            height: height,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: (message as ImageMessageModel).isLocal
                  ? ExtendedImage.file(File((message as ImageMessageModel).url))
                  : ExtendedImage.network((message as ImageMessageModel).url),
            ),
          );
        });
      case VideoMessageModel:
        return VideoMessagePlayer(
          message: message as VideoMessageModel,
        );
      case AudioMessageModel:
        return AudioMessagePlayer(
          message: message as AudioMessageModel,
          backgroundColor: backgroundColor,
          textColor:
              message.isFromMe ? COLORS.kWhiteColor : COLORS.kDarkBlueColor,
          iconColor:
              message.isFromMe ? COLORS.kWhiteColor : COLORS.kGreenMainColor,
          activeSliderColor:
              message.isFromMe ? COLORS.kWhiteColor : COLORS.kGreenMainColor,
          inactiveSliderColor: message.isFromMe
              ? COLORS.kWhiteColor.withOpacity(0.2)
              : COLORS.kDarkBlueColor.withOpacity(0.2),
        );
      case LocationMessageModel:
        return LocationMessageWidget(
          message: message as LocationMessageModel,
        );
      case LiveLocationMessageModel:
        return LiveLocationMessageWidget(
            message: message as LiveLocationMessageModel);
      case CallMessageModel:
        return CallMessageWidget(message: message as CallMessageModel);
      case FileMessageModel:
        return FileMessageWidget(message: message as FileMessageModel);

      case MultiMediaMessageModel:
        return MultiMediaMessageWidget(
            message: message as MultiMediaMessageModel);

      default:
        return const SizedBox.shrink();
    }
  }
}
