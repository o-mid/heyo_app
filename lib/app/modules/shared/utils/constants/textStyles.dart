import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heyo/app/modules/shared/utils/constants/fonts.dart';

class TEXTSTYLES {
  ///
  static TextStyle kHeaderDisplay = TextStyle(
    fontFamily: FONTS.interFamily,
    fontStyle: FontStyle.normal,
    fontWeight: FONTS.ExtraBold,
    fontSize: 24.0.sp,
    height: 1.29,
  );

  static TextStyle kHeaderLarge = TextStyle(
    fontFamily: FONTS.interFamily,
    fontStyle: FontStyle.normal,
    fontWeight: FONTS.Bold,
    fontSize: 19.0.sp,
    height: 1.31,
  );

  static TextStyle kHeaderMedium = TextStyle(
      fontFamily: FONTS.interFamily,
      fontStyle: FontStyle.normal,
      fontWeight: FONTS.Bold,
      fontSize: 15.0.sp,
      height: 1.33);

  ///

  static TextStyle kBodyBasic = TextStyle(
      fontFamily: FONTS.interFamily,
      fontStyle: FontStyle.normal,
      fontWeight: FONTS.Regular,
      fontSize: 15.0.sp,
      height: 1.46);

  static TextStyle kBodySmall = TextStyle(
    fontFamily: FONTS.interFamily,
    fontStyle: FontStyle.normal,
    fontWeight: FONTS.Regular,
    fontSize: 13.0.sp,
    height: 1.38,
  );
  static TextStyle kBodyTag = TextStyle(
    fontFamily: FONTS.interFamily,
    fontStyle: FontStyle.normal,
    fontWeight: FONTS.Medium,
    fontSize: 11.0.sp,
    height: 1.36,
  );

  ///

  static TextStyle kButtonBasic = TextStyle(
      fontFamily: FONTS.interFamily,
      fontStyle: FontStyle.normal,
      fontWeight: FONTS.SemiBold,
      fontSize: 15.0.sp,
      height: 1.2);

  static TextStyle kButtonSmall = TextStyle(
      fontFamily: FONTS.interFamily,
      fontStyle: FontStyle.normal,
      fontWeight: FONTS.Medium,
      fontSize: 13.0.sp,
      height: 1.38);

  ///

  ///letter spacing set to 10% of the font size
  static TextStyle kTag = TextStyle(
    fontFamily: FONTS.interFamily,
    fontStyle: FontStyle.normal,
    fontWeight: FONTS.Medium,
    fontSize: 8.0.sp,
    height: 1.25,
    letterSpacing: 0.8,
  );

  ///
  static TextStyle kChatName = TextStyle(
      fontFamily: FONTS.interFamily,
      fontStyle: FontStyle.normal,
      fontWeight: FONTS.Medium,
      fontSize: 14.0.sp,
      height: 1.22);

  static TextStyle kChatText = TextStyle(
    fontFamily: FONTS.interFamily,
    fontStyle: FontStyle.normal,
    fontWeight: FONTS.Regular,
    fontSize: 13.0.sp,
    height: 1.22,
  );
  static TextStyle kChatLink = TextStyle(
    fontFamily: FONTS.interFamily,
    fontStyle: FontStyle.normal,
    fontWeight: FONTS.Regular,
    fontSize: 13.0.sp,
    height: 1.22,
  );

  ///
  static TextStyle kLinkBig = TextStyle(
    fontFamily: FONTS.interFamily,
    fontStyle: FontStyle.normal,
    fontWeight: FONTS.Medium,
    fontSize: 15.0.sp,
    height: 1.46,
  );
  static TextStyle kLinkSmall = TextStyle(
    fontFamily: FONTS.interFamily,
    fontStyle: FontStyle.normal,
    fontWeight: FONTS.Medium,
    fontSize: 13.0.sp,
    height: 1.38,
  );
}
