import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/controllers/messages_controller.dart';
import 'package:heyo/app/modules/messages/data/models/messages/message_model.dart';
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
      children: _buildReactionsList(),
    );
  }

  List<Widget> _buildReactionsList() {
    return message.reactions.keys
        .map((emoji) => _buildReaction(emoji, message.reactions[emoji]!))
        .where((widget) => widget != null)
        .cast<Widget>()
        .toList();
  }

  Widget? _buildReaction(String emoji, ReactionModel reaction) {
    if (reaction.users.isEmpty) {
      return null;
    }

    final bool isReactedByMe = reaction.isReactedByMe;

    return Ink(
      decoration: BoxDecoration(
        color: isReactedByMe ? COLORS.kGreenLighterColor : null,
        border: Border.all(
          color: isReactedByMe ? COLORS.kGreenMainColor : COLORS.kPinCodeDeactivateColor,
          width: 1.w,
        ),
        borderRadius: BorderRadius.circular(4.w),
      ),
      child: InkWell(
        onTap: () => _handleReactionTap(emoji),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(emoji, style: TEXTSTYLES.kReactionEmoji),
              if (reaction.users.length > 1) ..._buildReactionCount(reaction),
            ],
          ),
        ),
      ),
    );
  }

  void _handleReactionTap(String emoji) {
    Get.find<MessagesController>().toggleReaction(message, emoji);
  }

  List<Widget> _buildReactionCount(ReactionModel reaction) {
    final isReactedByMe = reaction.isReactedByMe;
    return [
      SizedBox(width: 4.w),
      Text(
        reaction.users.length.toString(),
        style: TEXTSTYLES.kReactionNumber.copyWith(
          color: isReactedByMe ? COLORS.kGreenMainColor : COLORS.kTextBlueColor,
        ),
      ),
    ];
  }
}
