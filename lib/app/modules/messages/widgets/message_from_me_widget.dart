import 'package:flutter/material.dart';
import 'package:heyo/app/modules/messages/data/models/message_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/generated/assets.gen.dart';

import 'message_body_widget.dart';

class MessageFromMeWidget extends StatelessWidget {
  final MessageModel message;
  const MessageFromMeWidget({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(width: 16),
              Text(
                "${message.timestamp.hour.toString().padLeft(2, '0')}:${message.timestamp.minute.toString().padLeft(2, '0')}",
                style: TEXTSTYLES.kBodyTag.copyWith(
                  color: COLORS.kTextBlueColor,
                  fontSize: 10,
                ),
              ),
              SizedBox(width: 4),
              if (message.status == MESSAGE_STATUS.READ) Assets.svg.readIcon.svg(),
            ],
          ),
          MessageBodyWidget(
            backgroundColor: COLORS.kGreenMainColor,
            textColor: COLORS.kWhiteColor,
            message: message,
          ),
        ],
      ),
    );
  }
}
