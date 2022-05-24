import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/fonts.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/widgets/curtom_circle_avatar.dart';
import 'package:heyo/generated/assets.gen.dart';

import '../controllers/call_controller.dart';

class CallView extends GetView<CallController> {
  const CallView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLORS.kCallPageDarkGrey,
      appBar: AppBar(
        backgroundColor: COLORS.kCallPageDarkBlue,
        title: Text(
          'Boiled Dancer', // Todo
          style: TEXTSTYLES.kHeaderMedium.copyWith(
            height: 1.21,
            fontWeight: FONTS.SemiBold,
            color: COLORS.kWhiteColor,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            splashRadius: 18,
            icon: Assets.svg.volumeUp.svg(),
          ),
          IconButton(
            onPressed: () {},
            splashRadius: 18,
            icon: Assets.svg.cameraSwitch.svg(),
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              children: [
                SizedBox(height: 105.h),
                const CustomCircleAvatar(
                  url: "https://avatars.githubusercontent.com/u/6645136?v=4", // Todo
                  size: 64,
                ),
                SizedBox(height: 24.h),
                Text(
                  'Boiled Dancer', // Todo
                  style: TEXTSTYLES.kHeaderLarge.copyWith(
                    color: COLORS.kWhiteColor,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  "CB11...28BE", // Todo
                  style: TEXTSTYLES.kBodySmall.copyWith(
                    color: COLORS.kWhiteColor.withOpacity(0.6),
                  ),
                ),
                SizedBox(height: 40.h),
                Text(
                  "Ringing...", // Todo
                  style: TEXTSTYLES.kBodyBasic.copyWith(
                    color: COLORS.kWhiteColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
