import 'package:flutter/material.dart';

import '../utils/constants/colors.dart';
import '../utils/constants/textStyles.dart';

class AppBarWidget extends PreferredSize {
  final String title;
  final List<Widget>? actions;
  AppBarWidget({
    super.key,
    this.actions,
    required this.title,
  }) : super(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            centerTitle: false,
            elevation: 0,
            backgroundColor: COLORS.kGreenMainColor,
            title: Text(
              title,
              style: TEXTSTYLES.kHeaderLarge,
            ),
            automaticallyImplyLeading: false,
            actions: actions,
          ),
        );
}
