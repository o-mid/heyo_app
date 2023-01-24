import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../generated/locales.g.dart';
import '../../shared/utils/constants/colors.dart';
import '../../shared/utils/constants/fonts.dart';
import '../controllers/wifi_direct_controller.dart';

class WifiDirectView extends GetView<WifiDirectController> {
  const WifiDirectView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: COLORS.kGreenMainColor,
        elevation: 0,
        centerTitle: false,
        title: Text(
          LocaleKeys.newChat_wifiDirect_wifiDirectAppbar.tr,
          style: const TextStyle(
            fontWeight: FONTS.Bold,
            fontFamily: FONTS.interFamily,
          ),
        ),
        automaticallyImplyLeading: true,
      ),
      body: const Center(
        child: Text(
          'WifiDirectView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
