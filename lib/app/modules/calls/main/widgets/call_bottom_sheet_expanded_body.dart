import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/main/controllers/call_controller.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/extensions/core_id.extension.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/widgets/circle_icon_button.dart';
import 'package:heyo/app/modules/shared/widgets/curtom_circle_avatar.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';

class CallBottomSheetExpandedBody extends StatelessWidget {
  const CallBottomSheetExpandedBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CallController>();
    return Container(
      color: COLORS.kCallPageDarkBlue,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CircleIconButton.p16(
                  onPressed: controller.recordCall,
                  backgroundColor: COLORS.kCallPageDarkGrey,
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
                CircleIconButton.p16(
                  icon: Assets.svg.shareScreen.svg(color: COLORS.kWhiteColor),
                  backgroundColor: COLORS.kCallPageDarkGrey,
                ),

                /// The following two are only here to match the top row which has four buttons
                Opacity(
                  opacity: 0,
                  child: CircleIconButton.p16(
                    icon: Assets.svg.muteMicIcon.svg(),
                    backgroundColor: Colors.transparent,
                  ),
                ),
                Opacity(
                  opacity: 0,
                  child: CircleIconButton.p16(
                    icon: Assets.svg.callEnd.svg(),
                    backgroundColor: Colors.transparent,
                  ),
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
                CircleIconButton(
                  icon: Assets.svg.addParticipant.svg(),
                  backgroundColor: Colors.transparent,
                  onPressed: controller.addParticipant,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 100.h,
            child: Obx(() {
              return ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                itemCount: controller.participants.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      CustomCircleAvatar(
                        url: controller.participants[index].icon,
                        size: 40,
                      ),
                      CustomSizes.mediumSizedBoxWidth,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.participants[index].name,
                            style: TEXTSTYLES.kChatName.copyWith(color: COLORS.kWhiteColor),
                          ),
                          Text(
                            controller.participants[index].walletAddress.shortenCoreId,
                            style: TEXTSTYLES.kBodySmall.copyWith(
                              color: COLORS.kWhiteColor.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
                separatorBuilder: (_, __) => SizedBox(height: 16.h),
              );
            }),
          ),
        ],
      ),
    );
  }
}
