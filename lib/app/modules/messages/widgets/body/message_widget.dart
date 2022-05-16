import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heyo/app/modules/messages/data/models/messages/message_model.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/widgets/curtom_circle_avatar.dart';

import 'message_body_widget.dart';
import 'message_header_widget.dart';

class MessageWidget extends StatelessWidget {
  final MessageModel message;
  const MessageWidget({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!message.isFromMe) CustomSizes.mediumSizedBoxWidth,
        if (!message.isFromMe) CustomCircleAvatar(url: message.senderAvatar, size: 20),
        Expanded(
          child: Column(
            children: [
              MessageHeaderWidget(message: message),
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
