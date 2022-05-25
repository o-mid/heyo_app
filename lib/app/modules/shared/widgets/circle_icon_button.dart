import 'package:flutter/material.dart';

class CircleIconButton extends StatelessWidget {
  final Color backgroundColor;
  final VoidCallback onPressed;
  final EdgeInsetsGeometry? padding;
  final double? size;
  final Widget icon;

  const CircleIconButton({
    super.key,
    required this.backgroundColor,
    required this.onPressed,
    this.padding,
    this.size,
    required this.icon,
  });

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
