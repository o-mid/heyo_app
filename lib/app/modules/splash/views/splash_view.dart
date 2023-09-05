import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/splash/controllers/splash_controller.dart';
import 'package:heyo/generated/assets.gen.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        color: COLORS.kGreenMainColor,
        child: Center(
          child: Assets.png.splash.image(),
        ),
      ),
    );
  }
}
