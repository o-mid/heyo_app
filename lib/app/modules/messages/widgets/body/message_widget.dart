import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heyo/app/modules/messages/data/models/messages/message_model.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/widgets/curtom_circle_avatar.dart';

import '../../../shared/utils/constants/colors.dart';
import 'message_body_widget.dart';
import 'message_header_widget.dart';

class MessageWidget extends StatelessWidget {
  final MessageModel message;
  final bool isMockMessage;

  const MessageWidget({
    Key? key,
    required this.message,
    this.isMockMessage = false,
  }) : super(key: key);

  List<Widget> _buildChildren() {
    List<Widget> children = [];

    if (!message.isFromMe) {
      children.add(CustomSizes.mediumSizedBoxWidth);
      children.add(
        CustomCircleAvatar(
          url: message.senderAvatar,
          size: 20,
          isMockData: isMockMessage,
        ),
      );
    }

    children.add(
      Expanded(
        child: Column(
          children: [
            MessageHeaderWidget(message: message, isMockMessage: isMockMessage),
            SizedBox(height: 4.h),
            MessageBodyWidget(
              message: message,
              isMockMessage: isMockMessage,
            ),
          ],
        ),
      ),
    );

    return children;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _buildChildren(),
    );
  }
}
