import 'package:flutter/material.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';

class AppBarWidget extends PreferredSize {
  AppBarWidget({
    required this.title,
    super.key,
    this.backgroundColor,
    this.actions,
    this.leading,
    this.bottom,
    this.titleStyle,
    this.automaticallyImplyLeading,
  }) : super(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            centerTitle: false,
            automaticallyImplyLeading: automaticallyImplyLeading ?? true,
            elevation: 0,
            backgroundColor: backgroundColor ?? COLORS.kGreenMainColor,
            title: Text(
              title,
              style: titleStyle ?? TEXTSTYLES.kHeaderLarge,
            ),
            //automaticallyImplyLeading: false,
            actions: actions,
            bottom: bottom,
            leading: leading,
          ),
        );

  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final Color? backgroundColor;
  final PreferredSizeWidget? bottom;
  final TextStyle? titleStyle;
  final bool? automaticallyImplyLeading;
}
