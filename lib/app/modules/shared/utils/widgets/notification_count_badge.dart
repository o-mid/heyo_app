import 'package:flutter/material.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/fonts.dart';

class NotificationCountBadge extends StatelessWidget {
  final Color backgroundColor;
  final int count;
  const NotificationCountBadge({
    Key? key,
    required this.backgroundColor,
    required this.count,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 16,
      width: 16,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Text(
        count > 9 ? '9+' : count.toString(),
        style: TextStyle(
          color: COLORS.kWhiteColor,
          fontSize: 8,
          fontFamily: FONTS.interFamily,
        ),
      ),
    );
  }
}
