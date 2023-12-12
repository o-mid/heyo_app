import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/main/controllers/call_controller.dart';
import 'package:heyo/app/modules/calls/shared/widgets/callee_or_caller_info_widget.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/extensions/core_id.extension.dart';

class CalleeNoVideoWidget extends StatelessWidget {
  const CalleeNoVideoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CallController>();
    final user = controller.args.user;
    return Column(
      children: [
        SizedBox(height: 105.h),
        CalleeOrCallerInfoWidget(
          coreId: user.coreId,
          name: user.name,
          isContact: user.isContact,
          shortenCoreId: user.coreId.shortenCoreId,
        ),
        SizedBox(height: 40.h),
        Obx(() {
          return Text(
            "${controller.callDurationSeconds.value ~/ 60}:${(controller.callDurationSeconds.value % 60).toString().padLeft(2, "0")}",
            style: TEXTSTYLES.kBodyBasic.copyWith(color: COLORS.kWhiteColor),
          );
        }),
      ],
    );
  }
}
