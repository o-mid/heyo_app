import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../generated/assets.gen.dart';
import '../../../shared/utils/constants/colors.dart';

class EmojiPickerButtonWidget extends StatelessWidget {
  const EmojiPickerButtonWidget({
    Key? key,
    this.padding,
    required this.onTap,
  }) : super(key: key);
  final EdgeInsetsGeometry? padding;
  final GestureTapCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        shape: const CircleBorder(),
        side: const BorderSide(
          color: Colors.transparent,
        ),
        minimumSize: Size.zero,
        padding: EdgeInsets.zero,
      ),
      child: Container(
        padding: padding ?? const EdgeInsets.all(12),
        child: Assets.svg.emojiIcon.svg(color: COLORS.kDarkBlueColor, height: 22.h),
      ),
    );
  }
}
