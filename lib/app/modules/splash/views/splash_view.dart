import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/inputs/custom_text_field.dart';
import 'package:heyo/generated/assets.gen.dart';

import 'package:shimmer_animation/shimmer_animation.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Shimmer(
        child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            color: COLORS.kGreenMainColor,
            // child: Center(child: Assets.svg.heyoLogo.svg())
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 60,
                  child: CUSTOMTEXTFIELD(
                    labelText: "FFFFFF",
                    rightWidget: Icon(
                      Icons.search,
                    ),
                  ),
                ),
              ],
            ))),
      ),
    );
  }
}
