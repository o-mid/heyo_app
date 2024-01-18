import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:heyo/app/modules/account/controllers/account_controller.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/extensions/core_id.extension.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/widgets/curtom_circle_avatar.dart';
import 'package:heyo/app/routes/app_pages.dart';
import 'package:heyo/generated/assets.gen.dart';

class AccountHeaderWidget extends GetView<AccountController> {
  const AccountHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 23.h),
        Row(
          children: [
            const Spacer(),
            GestureDetector(
              onTap: () => Get.toNamed(Routes.SHREABLE_QR),
              child: Assets.svg.qrCode.svg(
                width: 20.w,
                fit: BoxFit.fitWidth,
              ),
            ),
            SizedBox(width: 23.w),
          ],
        ),
        CustomCircleAvatar(
          coreId: controller.coreId.value,
          size: 64,
        ),
        CustomSizes.mediumSizedBoxHeight,
        Text(
          "Scrambled Gurgle",
          style: TEXTSTYLES.kHeaderLarge.copyWith(color: COLORS.kDarkBlueColor),
        ),
        SizedBox(height: 4.h),
        Text(
          controller.coreId.value.shortenCoreId,
          style:
              TEXTSTYLES.kBodySmall.copyWith(color: COLORS.kTextSoftBlueColor),
        ),
        SizedBox(height: 60.h),
        const Divider(
          color: COLORS.kChatStroke,
          thickness: 1,
        ),
      ],
    );
  }
}
