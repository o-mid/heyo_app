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
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                margin: EdgeInsets.only(bottom: 4.h),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  message.payload,
                  style: TEXTSTYLES.kChatText.copyWith(color: textColor),
                ),
              ),
              if (message.reactions.isNotEmpty) ReactionsWidget(reactions: message.reactions),
            ],
          ),
        ),
        Spacer(),
      ],
    );
  }
}
