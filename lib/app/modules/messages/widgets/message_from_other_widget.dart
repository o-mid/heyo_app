import 'package:flutter/material.dart';
import 'package:heyo/app/modules/messages/data/models/message_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';

import 'message_body_widget.dart';

class MessageFromOtherWidget extends StatelessWidget {
  final MessageModel message;
  final bool showTimeAndProfile;
  const MessageFromOtherWidget({Key? key, required this.message, this.showTimeAndProfile = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(width: 16),
            if (showTimeAndProfile)
              Text(
                "${message.timestamp.hour.toString().padLeft(2, '0')}:${message.timestamp.minute.toString().padLeft(2, '0')}",
                style: TEXTSTYLES.kBodyTag.copyWith(
                  color: COLORS.kTextBlueColor,
                  fontSize: 10,
                ),
              ),
          ],
        ),
        MessageBodyWidget(
          backgroundColor: COLORS.kPinCodeDeactivateColor,
          textColor: COLORS.kDarkBlueColor,
          message: message,
        ),
      ],
    );
  }
}
