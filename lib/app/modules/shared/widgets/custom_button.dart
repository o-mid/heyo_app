import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final bool takeFullWidth;
  final EdgeInsets? padding;
  const CustomButton({
    Key? key,
    required this.title,
    this.onTap,
    this.borderRadius,
    this.backgroundColor,
    this.textStyle,
    this.takeFullWidth = true,
    this.padding,
  }) : super(key: key);

  final disabledOpacity = 0.4;
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: onTap != null ? 1 : disabledOpacity,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius ?? BorderRadius.circular(8.w),
        child: Container(
          width: takeFullWidth ? double.infinity : null,
          padding: padding ?? EdgeInsets.symmetric(vertical: 9.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.w),
            color: backgroundColor?.withOpacity(
              onTap != null ? 1 : disabledOpacity,
            ),
          ),
          child: Text(
            title,
            style: textStyle,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
