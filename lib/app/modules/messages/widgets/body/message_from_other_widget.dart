import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heyo/app/modules/messages/data/models/messages/message_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/widgets/curtom_circle_avatar.dart';

import 'message_body_widget.dart';

class MessageFromOtherWidget extends StatelessWidget {
  final MessageModel message;
  const MessageFromOtherWidget({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomSizes.mediumSizedBoxWidth,
        CustomCircleAvatar(url: message.senderAvatar, size: 20),
        Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  CustomSizes.mediumSizedBoxWidth,
                  Text(
                    "${message.timestamp.hour.toString().padLeft(2, '0')}:${message.timestamp.minute.toString().padLeft(2, '0')}",
                    style: TEXTSTYLES.kBodyTag.copyWith(
                      color: COLORS.kTextBlueColor,
                      fontSize: 10.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              MessageBodyWidget(
                message: message,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
