import 'package:flutter/material.dart';
import 'package:heyo/app/modules/messages/data/models/message_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';

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
        SizedBox(width: 16),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.only(bottom: 4),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  message.payload,
                  style: TEXTSTYLES.kChatText.copyWith(color: textColor),
                ),
              ),
            ],
          ),
        ),
        Spacer(),
      ],
    );
  }
}
