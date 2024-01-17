import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:heyo/app/modules/calls/main/controllers/call_controller.dart';
import 'package:heyo/app/modules/calls/shared/widgets/callee_or_caller_info_widget.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/generated/locales.g.dart';

class CallRingingWidget extends GetView<CallController> {
  const CallRingingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 105.h),
          Obx(() {
            if (controller.connectedRemoteParticipates.isNotEmpty) {
              return CalleeOrCallerInfoWidget(
                coreId: controller.connectedRemoteParticipates[0].coreId,
                name: controller.connectedRemoteParticipates[0].name,
              );
            } else {
              return const SizedBox();
            }
          }),
          SizedBox(height: 40.h),
          Text(
            LocaleKeys.CallPage_ringing.tr,
            style: TEXTSTYLES.kBodyBasic.copyWith(
              color: COLORS.kWhiteColor,
            ),
          ),
        ],
      ),
    );
  }
}
