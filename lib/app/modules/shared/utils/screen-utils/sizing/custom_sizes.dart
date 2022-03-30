import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSizes {
  /// left and right : 20px , bottom : 16px
  static EdgeInsetsGeometry mainContentPadding =
      EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h);

  /// height: 8.h
  static SizedBox smallSizedBoxHeight = SizedBox(height: 8.h);

  ///height: 16.h
  static SizedBox mediumSizedBoxHeight = SizedBox(height: 16.h);

  ///height: 24.h
  static SizedBox largeSizedBoxHeight = SizedBox(height: 24.h);
}
