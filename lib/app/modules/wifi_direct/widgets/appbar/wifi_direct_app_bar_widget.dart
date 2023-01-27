import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';

import '../../../../../generated/locales.g.dart';
import '../../../shared/utils/constants/fonts.dart';

AppBar wifiDirectAppBarWidget() {
  return AppBar(
    backgroundColor: COLORS.kGreenMainColor,
    elevation: 0,
    centerTitle: false,
    title: Text(
      LocaleKeys.wifiDirect_wifiDirectAppbar.tr,
      style: const TextStyle(
        fontWeight: FONTS.Bold,
        fontFamily: FONTS.interFamily,
      ),
    ),
    automaticallyImplyLeading: true,
  );
}
