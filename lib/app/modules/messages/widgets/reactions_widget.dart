import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/controllers/messages_controller.dart';
import 'package:heyo/app/modules/messages/data/models/message_model.dart';
import 'package:heyo/app/modules/messages/data/models/reaction_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';

class ReactionsWidget extends StatelessWidget {
  final MessageModel message;
  const ReactionsWidget({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4.w,
      runSpacing: 4.h,
      children:
          message.reactions.keys.map((k) => _buildReaction(k, message.reactions[k]!)).toList(),
    );
  }

  Widget _buildReaction(String emoji, ReactionModel reaction) {
    if (reaction.users.length == 0) {
      return SizedBox.shrink();
    }

    return Ink(
      decoration: BoxDecoration(
        color: reaction.isReactedByMe ? COLORS.kGreenLighterColor : null,
        border: Border.all(
          color: reaction.isReactedByMe ? COLORS.kGreenMainColor : COLORS.kPinCodeDeactivateColor,
          width: 1.w,
        ),
        borderRadius: BorderRadius.circular(4.w),
      ),
      child: InkWell(
        onTap: () {
          Get.find<MessagesController>().toggleReaction(message, emoji);
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                emoji,
                style: TEXTSTYLES.kReactionEmoji,
              ),
              SizedBox(width: 4.w),
              Text(
                reaction.users.length.toString(),
                style: TEXTSTYLES.kReactionNumber.copyWith(
                  color: reaction.isReactedByMe ? COLORS.kGreenMainColor : COLORS.kTextBlueColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
