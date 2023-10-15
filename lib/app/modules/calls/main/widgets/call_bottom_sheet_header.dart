import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/main/controllers/call_controller.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/widgets/circle_icon_button.dart';
import 'package:heyo/generated/assets.gen.dart';

class CallBottomSheetHeader extends GetView<CallController> {
  const CallBottomSheetHeader({super.key});

  @override
  Widget build(BuildContext context) {
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
                Obx(() {
                  final localParticipate = controller.localParticipate.value;
                  if (localParticipate == null) {
                    return Container();
                  }

                  return _buildEnabledOrDisabledButton(
                    isEnabled: localParticipate!.videoMode.value,
                    enabled: Assets.svg.videoCallIcon.svg(
                      color: COLORS.kWhiteColor,
                    ),
                    disabled: Assets.svg.videoDisabled.svg(
                      color: COLORS.kWhiteColor,
                    ),
                    onPressed: controller.toggleVideo,
                  );
                }),
                CircleIconButton.p16(
                  onPressed: () {
                    controller.message();
                  }, // Todo
                  backgroundColor: COLORS.kCallPageDarkGrey,
                  icon: Assets.svg.chatOutlined.svg(
                    color: COLORS.kWhiteColor,
                  ),
                ),
                Obx(() {
                  final localParticipate = controller.localParticipate.value;
                  if (localParticipate == null) {
                    return Container();
                  }

                  return _buildEnabledOrDisabledButton(
                    isEnabled: localParticipate!.audioMode.isTrue,
                    enabled: Assets.svg.recordIcon.svg(
                      color: COLORS.kWhiteColor,
                    ),
                    disabled: Assets.svg.muteMicIcon.svg(
                      color: COLORS.kWhiteColor,
                    ),
                    onPressed: controller.toggleMuteMic,
                  );
                }),
                CircleIconButton.p16(
                  onPressed: controller.endCall,
                  backgroundColor: COLORS.kStatesErrorColor,
                  icon: Assets.svg.callEnd.svg(
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

  Widget _buildEnabledOrDisabledButton({
    required Widget enabled,
    required Widget disabled,
    required bool isEnabled,
    VoidCallback? onPressed,
  }) {
    return CircleIconButton(
      onPressed: onPressed,
      padding: EdgeInsets.all(15.w),
      backgroundColor:
          isEnabled ? COLORS.kCallPageDarkGrey : COLORS.kCallPageDarkBlue,
      border: Border.all(color: COLORS.kCallPageDarkGrey, width: 1.w),
      icon: isEnabled ? enabled : disabled,
    );
  }
}
