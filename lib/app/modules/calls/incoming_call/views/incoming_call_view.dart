import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:heyo/app/modules/calls/incoming_call/controllers/incoming_call_controller.dart';
import 'package:heyo/app/modules/calls/shared/widgets/callee_or_caller_info_widget.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/extensions/core_id.extension.dart';
import 'package:heyo/app/modules/shared/widgets/circle_icon_button.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';

class IncomingCallView extends GetView<IncomingCallController> {
  const IncomingCallView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLORS.kDarkBlueColor,
      body: Obx(() {
        return Column(
          children: [
            SizedBox(height: 105.h),
            if (controller.caller.value != null)
              CalleeOrCallerInfoWidget(
                iconUrl: controller.caller.value!.iconUrl,
                name: controller.caller.value!.name,
                isContact: controller.caller.value!.isContact,
                shortenCoreId: controller.caller.value!.coreId.shortenCoreId,
              ),
            SizedBox(height: 40.h),
            Text(
              controller.args.isAudioCall
                  ? LocaleKeys.IncomingCallPage_incomingVoiceCall.tr
                  : LocaleKeys.IncomingCallPage_incomingVideoCall.tr,
              style: TEXTSTYLES.kBodyBasic.copyWith(color: COLORS.kWhiteColor),
            ),
            SizedBox(height: 40.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleIconButton(
                  onPressed: controller.goToChat,
                  backgroundColor: COLORS.kCallPageDarkGrey,
                  icon: Assets.svg.chatOutlined.svg(),
                ),
                Obx(() {
                  return controller.muted.value
                      ? const SizedBox.shrink()
                      : Row(
                          children: [
                            SizedBox(width: 24.w),
                            CircleIconButton(
                              onPressed: controller.mute,
                              backgroundColor: COLORS.kCallPageDarkGrey,
                              icon: Assets.svg.muteSpeaker.svg(),
                            ),
                          ],
                        );
                }),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleIconButton(
                  onPressed: controller.declineCall,
                  backgroundColor: COLORS.kStatesErrorColor,
                  icon: Assets.svg.callEnd.svg(),
                ),
                SizedBox(width: 100.w),
                CircleIconButton(
                  onPressed: controller.acceptCall,
                  backgroundColor: COLORS.kStatesSuccessColor,
                  icon: controller.args.isAudioCall
                      ? Assets.svg.audioCallIcon.svg()
                      : Assets.svg.videoCallIcon.svg(),
                ),
              ],
            ),
            SizedBox(height: 80.h),
          ],
        );
      }),
    );
  }
}
