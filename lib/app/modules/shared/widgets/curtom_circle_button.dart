import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';

class CustomCircleButton extends StatelessWidget {
  const CustomCircleButton({
    required this.size,
    required this.onPressed,
    required this.icon,
    super.key,
  });

  final double size;

  final void Function()? onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.w,
      height: size.w,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: COLORS.kMessageSelectionOption,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: icon,
      ),
    );
  }
}
