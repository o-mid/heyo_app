import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';

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
      height: 16.w,
      width: 16.w,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Text(count > 9 ? '9+' : count.toString(),
          style: TEXTSTYLES.kTag.copyWith(
            color: COLORS.kWhiteColor,
          )),
    );
  }
}
