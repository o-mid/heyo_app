import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/generated/locales.g.dart';
import '../../shared/utils/constants/textStyles.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SplashView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          //test to see generated locals are working
          LocaleKeys.registration_WelcomePage_title.tr,
          style: TEXTSTYLES.kHeaderLarge,
        ),
      ),
    );
  }
}
