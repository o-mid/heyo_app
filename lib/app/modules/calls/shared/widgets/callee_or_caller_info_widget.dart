import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/extensions/core_id.extension.dart';
import 'package:heyo/app/modules/shared/widgets/curtom_circle_avatar.dart';

class CalleeOrCallerInfoWidget extends StatelessWidget {
  const CalleeOrCallerInfoWidget({
    required this.name,
    required this.coreId,
    super.key,
  });

  final String name;
  final String coreId;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomCircleAvatar(
          coreId: coreId,
          size: 64,
        ),
        SizedBox(height: 24.h),
        Text(
          name,
          style: TEXTSTYLES.kHeaderLarge.copyWith(
            color: COLORS.kWhiteColor,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          coreId.shortenCoreId,
          style: TEXTSTYLES.kBodySmall.copyWith(
            color: COLORS.kWhiteColor.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}
