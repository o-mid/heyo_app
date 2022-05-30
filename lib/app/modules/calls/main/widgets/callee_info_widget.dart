import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/main/controllers/call_controller.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';

import 'package:heyo/app/modules/shared/utils/extensions/core_id.extension.dart';
import 'package:heyo/app/modules/shared/widgets/curtom_circle_avatar.dart';

class CalleeInfoWidget extends StatelessWidget {
  const CalleeInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CallController>();
    return Column(
      children: [
        CustomCircleAvatar(
          url: controller.args.user.icon,
          size: 64,
        ),
        SizedBox(height: 24.h),
        Text(
          controller.args.user.name,
          style: TEXTSTYLES.kHeaderLarge.copyWith(
            color: COLORS.kWhiteColor,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          controller.args.user.walletAddress.shortenCoreId,
          style: TEXTSTYLES.kBodySmall.copyWith(
            color: COLORS.kWhiteColor.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}
