import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../generated/assets.gen.dart';
import '../../../shared/utils/constants/colors.dart';

class MediaGlassmorphicButtonWidget extends StatelessWidget {
  const MediaGlassmorphicButtonWidget({
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
        padding: padding ?? const EdgeInsets.all(12),
      ),
      child: Container(
        width: 22.h,
        decoration: const BoxDecoration(
          color: COLORS.kGreenMainColor,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.add,
          color: COLORS.kWhiteColor,
        ),
      ),
    );
  }
}
