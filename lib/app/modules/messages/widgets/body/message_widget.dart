import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heyo/app/modules/messages/data/models/messages/message_model.dart';
import 'package:heyo/app/modules/messages/widgets/body/message_body_widget.dart';
import 'package:heyo/app/modules/messages/widgets/body/message_header_widget.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/widgets/curtom_circle_avatar.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget({
    required this.message,
    super.key,
    this.isMockMessage = false,
  });

  final MessageModel message;
  final bool isMockMessage;

  List<Widget> _buildChildren() {
    List<Widget> children = [];

    if (!message.isFromMe) {
      children
        ..add(CustomSizes.mediumSizedBoxWidth)
        ..add(
          CustomCircleAvatar(
            size: 20,
            coreId: message.chatId,
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
