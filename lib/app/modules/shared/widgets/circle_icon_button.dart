import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CircleIconButton extends StatelessWidget {
  final Color backgroundColor;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry? padding;
  final double? size;
  final Widget icon;

  const CircleIconButton({
    super.key,
    required this.backgroundColor,
    this.onPressed,
    this.padding,
    this.size,
    required this.icon,
  });

  factory CircleIconButton.p16({
    required backgroundColor,
    VoidCallback? onPressed,
    double? size,
    required Widget icon,
  }) =>
      CircleIconButton(
        padding: EdgeInsets.all(16.w),
        backgroundColor: backgroundColor,
        size: size,
        onPressed: onPressed,
        icon: icon,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Material(
        color: Colors.transparent,
        child: IconButton(
          padding: padding ?? EdgeInsets.zero,
          onPressed: onPressed,
          icon: icon,
        ),
      ),
    );
  }
}
