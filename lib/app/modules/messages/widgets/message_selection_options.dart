import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/controllers/messages_controller.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/fonts.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';

import '../../../routes/app_pages.dart';

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
    final controller = Get.find<MessagesController>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (showReply)
          _buildOption(
            Assets.svg.replyOutlined,
            LocaleKeys.reply.tr,
            onTap: controller.replyTo,
          ),
        if (showCopy)
          _buildOption(
            Assets.svg.copyIcon,
            LocaleKeys.copy.tr,
            onTap: controller.copySelectedToClipboard,
          ),
        if (showForward)
          _buildOption(
            Assets.svg.forwardIcon,
            LocaleKeys.forward.tr,
            onTap: (() => Get.toNamed(Routes.FORWARD_MASSAGES)),
          ),
        if (showDelete)
          _buildOption(
            Assets.svg.deleteIcon,
            LocaleKeys.delete.tr,
            onTap: controller.showDeleteSelectedDialog,
          ),
      ],
    );
  }

  Widget _buildOption(SvgGenImage icon, String text, {Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          icon.svg(
            color: COLORS.kMessageSelectionOption,
            width: 18.w,
            height: 14.w,
          ),
          SizedBox(height: 7.h),
          Text(
            text,
            style: TEXTSTYLES.kBodyTag.copyWith(
              color: COLORS.kMessageSelectionOption,
              fontWeight: FONTS.Bold,
            ),
          ),
        ],
      ),
    );
  }
}
