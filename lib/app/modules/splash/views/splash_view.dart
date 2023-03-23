import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:shimmer/shimmer.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Shimmer.fromColors(
        direction: ShimmerDirection.ltr,
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            color: COLORS.kGreenMainColor,
            child: Center(child: Assets.svg.heyoLogo.svg())),
      ),
    );
  }
}
