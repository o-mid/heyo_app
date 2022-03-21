import 'package:flutter/material.dart';
import '../../constants/textStyles.dart';
import '../../constants/colors.dart';

enum CustomButtonType {
  outline,
  fill,
}

enum CustomButtonSize { regular, small, extraSmall }

class CustomButton extends StatelessWidget {
  final Function? onTap;
  final String? title;
  final Widget? titleWidget;
  final bool canTap;
  final TextStyle? titleStyle;
  final CustomButtonType type;
  final CustomButtonSize size;
  final Color? color;
  final Icon? icon;

  CustomButton({
    required this.onTap,
    this.title,
    this.titleStyle,
    this.titleWidget,
    required this.size,
    this.canTap = true,
    this.type = CustomButtonType.fill,
    this.color,
    this.icon,
  });

  factory CustomButton.primary({
    Function? onTap,
    String? title,
    Widget? titleWidget,
    TextStyle? style,
    bool canTap = true,
    Color? color,
    Icon? icon,
  }) {
    return CustomButton(
      color: color ?? COLORS.kGreenMainColor,
      title: title,
      onTap: onTap,
      canTap: canTap,
      titleWidget: titleWidget,
      titleStyle: style,
      type: CustomButtonType.fill,
      size: CustomButtonSize.regular,
      icon: icon,
    );
  }

  factory CustomButton.outline({
    Function? onTap,
    required String title,
    Widget? titleWidget,
    TextStyle? style,
    double? width,
    double? height,
    Icon? icon,
  }) {
    return CustomButton(
      title: title,
      onTap: onTap,
      titleStyle: style ??
          TEXTSTYLES.kButtonBasic.copyWith(color: COLORS.kGreenMainColor),
      titleWidget: titleWidget,
      type: CustomButtonType.outline,
      size: CustomButtonSize.regular,
      icon: icon,
    );
  }

  factory CustomButton.primarySmall({
    Function? onTap,
    String? title,
    Widget? titleWidget,
    TextStyle? style,
    Color? color,
    String? price,
    Icon? icon,
  }) {
    return CustomButton(
        color: color ?? COLORS.kGreenMainColor,
        title: title,
        onTap: onTap,
        titleWidget: titleWidget,
        titleStyle: style,
        type: CustomButtonType.fill,
        size: CustomButtonSize.small,
        icon: icon);
  }

  factory CustomButton.outlineSmall({
    Function? onTap,
    required String title,
    TextStyle? style,
    required double width,
    required double height,
    Icon? icon,
  }) {
    return CustomButton(
        title: title,
        onTap: onTap,
        titleStyle: style ??
            TEXTSTYLES.kButtonBasic.copyWith(color: COLORS.kGreenMainColor),
        type: CustomButtonType.outline,
        size: CustomButtonSize.small,
        icon: icon);
  }

  factory CustomButton.primaryExtraSmall({
    required Function onTap,
    required String title,
    Widget? titleWidget,
    TextStyle? style,
    Color? color,
    Icon? icon,
  }) {
    return CustomButton(
        color: color ?? COLORS.kGreenMainColor,
        title: title,
        onTap: onTap,
        titleWidget: titleWidget,
        titleStyle: style,
        type: CustomButtonType.fill,
        size: CustomButtonSize.extraSmall,
        icon: icon);
  }

  factory CustomButton.outlineExtraSmall({
    Function? onTap,
    required String title,
    TextStyle? style,
    required double width,
    required double height,
    Icon? icon,
  }) {
    return CustomButton(
      title: title,
      onTap: onTap,
      titleStyle: style ??
          TEXTSTYLES.kButtonBasic.copyWith(color: COLORS.kGreenMainColor),
      type: CustomButtonType.outline,
      size: CustomButtonSize.extraSmall,
      icon: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isOutline = this.type == CustomButtonType.outline;
    final haveIcon = icon != null;
    final decoration = BoxDecoration(
        color: color,
        border: isOutline
            ? Border.all(
                width: 1.0,
                color: COLORS.kGreenMainColor,
              )
            : null,
        borderRadius: BorderRadius.circular(8));

    final TextStyle style = size == CustomButtonSize.regular
        ? TEXTSTYLES.kButtonBasic
        : TEXTSTYLES.kButtonBasic;

    final EdgeInsets padding = size == CustomButtonSize.regular
        ? EdgeInsets.symmetric(horizontal: 20, vertical: 10)
        : size == CustomButtonSize.small
            ? EdgeInsets.symmetric(horizontal: 24, vertical: 10)
            : EdgeInsets.symmetric(horizontal: 16, vertical: 6);

    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
      ),
      onPressed: canTap ? onTap as void Function()? : null,
      child: Container(
        height: size == CustomButtonSize.regular
            ? 48
            : size == CustomButtonSize.small
                ? 40
                : 32,
        padding: padding,
        decoration: decoration,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: CustomButtonSize.regular == size
              ? MainAxisSize.max
              : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon ?? SizedBox(),
            haveIcon
                ? SizedBox(
                    width: 8,
                  )
                : SizedBox(),
            titleWidget ??
                Text(
                  this.title!,
                  style: this.titleStyle ??
                      style.copyWith(
                          color: isOutline
                              ? COLORS.kGreenMainColor
                              : COLORS.kWhiteColor),
                  textHeightBehavior:
                      TextHeightBehavior(applyHeightToFirstAscent: false),
                ),
          ],
        ),
      ),
    );
  }
}
