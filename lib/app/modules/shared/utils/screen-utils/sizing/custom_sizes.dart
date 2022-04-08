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

  ///height: 48.h
  static SizedBox extraLargeSizedBoxHeight = SizedBox(height: 48.h);

  /// Width: 8.w
  static SizedBox smallSizedBoxWidth = SizedBox(width: 8.w);

  /// width: 16.w
  static SizedBox mediumSizedBoxWidth = SizedBox(width: 16.w);

  /// width: 24.w
  static SizedBox largeSizedBoxWidth = SizedBox(width: 24.w);

  /// width: 48.w
  static SizedBox extraLargeSizedBoxWidth = SizedBox(width: 48.w);
}
