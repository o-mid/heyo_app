import 'package:flutter/material.dart';
import 'package:heyo/app/modules/shared/utils/constants/fonts.dart';

class TEXTSTYLES {
  ///
  static const TextStyle kHeaderDisplay = TextStyle(
    fontFamily: FONTS.interFamily,
    fontStyle: FontStyle.normal,
    fontWeight: FONTS.ExtraBold,
    fontSize: 24.0,
    height: 1.29,
  );

  static const TextStyle kHeaderLarge = TextStyle(
    fontFamily: FONTS.interFamily,
    fontStyle: FontStyle.normal,
    fontWeight: FONTS.Bold,
    fontSize: 26.0,
    height: 1.0,
  );

  static const TextStyle kHeaderMedium = TextStyle(
      fontFamily: FONTS.interFamily,
      fontStyle: FontStyle.normal,
      fontWeight: FONTS.Bold,
      fontSize: 15.0,
      height: 1.33);

  ///

  static const TextStyle kBodyBasic = TextStyle(
      fontFamily: FONTS.interFamily,
      fontStyle: FontStyle.normal,
      fontWeight: FONTS.Regular,
      fontSize: 15.0,
      height: 1.46);

  TextStyle kBodySmall = TextStyle(
    fontFamily: FONTS.interFamily,
    fontStyle: FontStyle.normal,
    fontWeight: FONTS.Regular,
    fontSize: 13.0,
    height: 1.38,
  );
  static const TextStyle kBodyTag = TextStyle(
    fontFamily: FONTS.interFamily,
    fontStyle: FontStyle.normal,
    fontWeight: FONTS.Medium,
    fontSize: 11.0,
    height: 1.36,
  );

  ///

  static const TextStyle kButtonBasic = TextStyle(
      fontFamily: FONTS.interFamily,
      fontStyle: FontStyle.normal,
      fontWeight: FONTS.SemiBold,
      fontSize: 15.0,
      height: 1.2);

  static const TextStyle kButtonSmall = TextStyle(
      fontFamily: FONTS.interFamily,
      fontStyle: FontStyle.normal,
      fontWeight: FONTS.Medium,
      fontSize: 13.0,
      height: 1.38);

  ///

  ///letter spacing set to 10% of the font size
  static const TextStyle kTag = TextStyle(
    fontFamily: FONTS.interFamily,
    fontStyle: FontStyle.normal,
    fontWeight: FONTS.Medium,
    fontSize: 8.0,
    height: 1.25,
    letterSpacing: 0.8,
  );
}
