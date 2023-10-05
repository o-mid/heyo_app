import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CircleIconButton extends StatelessWidget {
  final Color backgroundColor;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry? padding;
  final double? size;
  final Widget icon;
  final BoxBorder? border;

  const CircleIconButton({
    super.key,
    required this.backgroundColor,
    this.onPressed,
    this.padding,
    this.size,
    required this.icon,
    this.border,
  });

  factory CircleIconButton.p16({
    required backgroundColor,
    VoidCallback? onPressed,
    double? size,
    BoxBorder? border,
    required Widget icon,
  }) =>
      CircleIconButton(
        padding: EdgeInsets.all(16.w),
        backgroundColor: backgroundColor as Color,
        size: size,
        onPressed: onPressed,
        border: border,
        icon: icon,
      );

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        border: border,
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
