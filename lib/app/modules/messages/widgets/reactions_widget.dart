import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heyo/app/modules/messages/data/models/message_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';

class ReactionsWidget extends StatelessWidget {
  final Map<String, ReactionModel> reactions;
  const ReactionsWidget({Key? key, required this.reactions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: reactions.keys.map((k) => _buildReaction(k, reactions[k]!)).toList(),
    );
  }

  Widget _buildReaction(String emoji, ReactionModel reaction) {
    if (reaction.users.length == 0) {
      return SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
      margin: EdgeInsetsDirectional.only(end: 4.w, bottom: 4.h),
      decoration: BoxDecoration(
        color: reaction.isReactedByMe ? COLORS.kGreenLighterColor : null,
        border: Border.all(
            color: reaction.isReactedByMe ? COLORS.kGreenMainColor : COLORS.kPinCodeDeactivateColor,
            width: 1.w),
        borderRadius: BorderRadius.circular(4.w),
      ),
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
    );
  }
}
