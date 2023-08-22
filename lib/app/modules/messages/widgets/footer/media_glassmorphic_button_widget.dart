import 'package:flutter/material.dart';

//import 'package:flutter_screenutil/flutter_screenutil.dart';
//import 'package:get/get.dart';

//import '../../../../../generated/assets.gen.dart';
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
      child: SizedBox(
        width: 40,
        height: 40,
        child: Center(
          child: Container(
            width: 24,
            height: 24,
            //padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              color: COLORS.kGreenMainColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.add,
              color: COLORS.kWhiteColor,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
