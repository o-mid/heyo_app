import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';

class ConnectionStatusBody extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final Color titleColor;
  const ConnectionStatusBody(
      {Key? key, required this.title, required this.backgroundColor, required this.titleColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: Container(
        color: backgroundColor,
        child: Center(
          child: Text(
            title,
            style: TEXTSTYLES.kBodySmall.copyWith(
              color: titleColor,
            ),
          ),
        ),
      ),
    );
  }
}
