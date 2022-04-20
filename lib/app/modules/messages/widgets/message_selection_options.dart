import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/fonts.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';

class MessageSelectionOptions extends StatelessWidget {
  final bool showReply;
  final bool showCopy;
  final bool showForward;
  final bool showDelete;
  const MessageSelectionOptions({
    Key? key,
    this.showReply = true,
    this.showCopy = true,
    this.showForward = true,
    this.showDelete = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (showReply) _buildOption(Assets.svg.replyOutlined, LocaleKeys.reply.tr),
        if (showCopy) _buildOption(Assets.svg.copyIcon, LocaleKeys.copy.tr),
        if (showForward) _buildOption(Assets.svg.forwardIcon, LocaleKeys.forward.tr),
        if (showDelete) _buildOption(Assets.svg.deleteIcon, LocaleKeys.delete.tr),
      ],
    );
  }

  Widget _buildOption(SvgGenImage icon, String text) {
    return Column(
      children: [
        icon.svg(),
        SizedBox(height: 7.h),
        Text(
          text,
          style: TEXTSTYLES.kBodyTag.copyWith(
            color: COLORS.kMessageSelectionOption,
            fontWeight: FONTS.Bold,
          ),
        ),
      ],
    );
  }
}
