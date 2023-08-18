import 'package:flutter/material.dart';

//import 'package:flutter_screenutil/flutter_screenutil.dart';
//import 'package:get/get.dart';

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
        ),
      ),
      child: Container(
        width: 40,
        height: 40,
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.fromLTRB(0, 8, 8, 8),
        child: Assets.svg.recordIcon.svg(
          color: COLORS.kDarkBlueColor,
        ),
      ),
    );
  }
}
