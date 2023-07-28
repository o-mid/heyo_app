import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../generated/assets.gen.dart';
import '../../../shared/utils/constants/colors.dart';

class RecordButtonWidget extends StatelessWidget {
  const RecordButtonWidget({
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
          minimumSize: Size.zero,
          padding: EdgeInsets.zero,
          side: const BorderSide(
            color: Colors.transparent,
          )),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(12),
        child:
            SizedBox(child: Assets.svg.recordIcon.svg(color: COLORS.kDarkBlueColor, height: 22.h)),
      ),
    );
  }
}
