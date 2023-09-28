import 'package:flutter/material.dart';

import '../utils/constants/colors.dart';
import '../utils/constants/textStyles.dart';

class AppBarWidget extends PreferredSize {
  final String title;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final PreferredSizeWidget? bottom;
  final TextStyle? titleStyle;
  AppBarWidget({
    super.key,
    required this.title,
    this.backgroundColor,
    this.actions,
    this.bottom,
    this.titleStyle,
  }) : super(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            centerTitle: false,
            elevation: 0,
            backgroundColor: backgroundColor ?? COLORS.kGreenMainColor,
            title: Text(
              title,
              style: titleStyle ?? TEXTSTYLES.kHeaderLarge,
            ),
            //automaticallyImplyLeading: false,
            actions: actions,
            bottom: bottom,
          ),
        );
}
