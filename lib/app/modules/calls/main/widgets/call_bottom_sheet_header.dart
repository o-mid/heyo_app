import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/main/controllers/call_controller.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/widgets/circle_icon_button.dart';
import 'package:heyo/generated/assets.gen.dart';

class CallBottomSheetHeader extends StatelessWidget {
  const CallBottomSheetHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CallController>();
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(bottom: 24.h),
      decoration: BoxDecoration(
        color: COLORS.kCallPageDarkBlue,
        borderRadius: BorderRadius.circular(20.r).copyWith(
          bottomLeft: Radius.zero,
          bottomRight: Radius.zero,
        ),
      ),
      child: Column(
        children: [
          CustomSizes.smallSizedBoxHeight,
          Assets.svg.bottomsheetHandle.svg(
            color: COLORS.kCallPageDarkGrey,
          ),
          CustomSizes.mediumSizedBoxHeight,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CircleIconButton(
                  onPressed: controller.toggleVideo,
                  backgroundColor: COLORS.kCallPageDarkGrey,
                  icon: Assets.svg.videoCallIcon.svg(color: COLORS.kWhiteColor),
                ),
                CircleIconButton.p16(
                  onPressed: () {}, // Todo
                  backgroundColor: COLORS.kCallPageDarkGrey,
                  icon: Assets.svg.chatOutlined.svg(color: COLORS.kWhiteColor),
                ),
                CircleIconButton.p16(
                  onPressed: controller.toggleMuteMic,
                  backgroundColor: COLORS.kCallPageDarkGrey,
                  icon: Assets.svg.muteIcon.svg(color: COLORS.kWhiteColor),
                ),
                CircleIconButton.p16(
                  onPressed: controller.endCall,
                  backgroundColor: COLORS.kStatesErrorColor,
                  icon: Assets.svg.callEnd.svg(color: COLORS.kWhiteColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
