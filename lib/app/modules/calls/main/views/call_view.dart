import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/fonts.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/widgets/curtom_circle_avatar.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';

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
            onPressed: controller.toggleMuteCall,
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
      body: ExpandableBottomSheet(
        background: Center(
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
                LocaleKeys.CallPage_ringing.tr,
                style: TEXTSTYLES.kBodyBasic.copyWith(
                  color: COLORS.kWhiteColor,
                ),
              ),
            ],
          ),
        ),
        expandableContent: Container(
          color: COLORS.kCallPageDarkBlue,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildCircleIconButton(
                      onPressed: controller.recordCall,
                      icon: Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 1.w,
                            color: COLORS.kWhiteColor,
                          ),
                        ),
                        child: Assets.svg.recordVoiceCircleIcon.svg(
                          width: 48.w,
                          height: 48.w,
                          color: COLORS.kStatesErrorColor,
                        ),
                      ),
                    ),
                    _buildCircleIconButton(
                      icon: Assets.svg.shareScreen.svg(color: COLORS.kWhiteColor),
                    ),

                    /// The following two are only here to match the top row which has four buttons
                    Opacity(
                      opacity: 0,
                      child: _buildCircleIconButton(icon: Assets.svg.muteIcon.svg()),
                    ),
                    Opacity(
                      opacity: 0,
                      child: _buildCircleIconButton(icon: Assets.svg.callEnd.svg()),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              Container(color: const Color(0xff272D3D), height: 8.h),
              SizedBox(height: 8.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  children: [
                    Text(
                      LocaleKeys.CallPage_participants.tr,
                      style: TEXTSTYLES.kLinkSmall.copyWith(
                        color: COLORS.kTextSoftBlueColor,
                      ),
                    ),
                    const Spacer(),
                    _buildCircleIconButton(
                      icon: Assets.svg.addParticipant.svg(),
                      backgroundColor: Colors.transparent,
                      onPressed: controller.addParticipant,
                    ),
                  ],
                ),
              ),
              // Todo: fix
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const CustomCircleAvatar(
                            url: "https://avatars.githubusercontent.com/u/6645136?v=4", // Todo
                            size: 40,
                          ),
                          CustomSizes.mediumSizedBoxWidth,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Boiled Dancer",
                                style: TEXTSTYLES.kChatName.copyWith(color: COLORS.kWhiteColor),
                              ),
                              Text(
                                "CB11...28BE", // Todo
                                style: TEXTSTYLES.kBodySmall.copyWith(
                                  color: COLORS.kWhiteColor.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
        persistentHeader: Container(
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
                    _buildCircleIconButton(
                      onPressed: controller.toggleVideo,
                      backgroundColor: COLORS.kWhiteColor,
                      icon: Assets.svg.videoCallIcon.svg(color: COLORS.kDarkBlueColor),
                    ),
                    _buildCircleIconButton(
                      onPressed: () {}, // Todo
                      icon: Assets.svg.chatOutlined.svg(color: COLORS.kWhiteColor),
                    ),
                    _buildCircleIconButton(
                      onPressed: controller.toggleMuteMic,
                      icon: Assets.svg.muteIcon.svg(color: COLORS.kWhiteColor),
                    ),
                    _buildCircleIconButton(
                      onPressed: controller.endCall,
                      backgroundColor: COLORS.kStatesErrorColor,
                      icon: Assets.svg.callEnd.svg(color: COLORS.kWhiteColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircleIconButton({
    required Widget icon,
    Color backgroundColor = COLORS.kCallPageDarkGrey,
    VoidCallback? onPressed,
  }) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Material(
        color: Colors.transparent,
        child: IconButton(
          padding: EdgeInsets.all(16.w),
          onPressed: onPressed,
          icon: icon,
        ),
      ),
    );
  }
}
