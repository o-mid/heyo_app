import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';

class ListHeaderWidget extends StatelessWidget {
  const ListHeaderWidget({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomSizes.mediumSizedBoxHeight,
        Row(
          children: [
            SizedBox(
              width: 10.w,
              child: const Divider(
                color: COLORS.kDividerColor,
                thickness: 2,
              ),
            ),
            CustomSizes.smallSizedBoxWidth,
            Text(
              title,
              style: TEXTSTYLES.kLinkBig.copyWith(color: COLORS.kDarkBlueColor),
            ),
            CustomSizes.smallSizedBoxWidth,
            const Expanded(
              child: Divider(
                color: COLORS.kDividerColor,
                thickness: 2,
              ),
            ),
          ],
        ),
        CustomSizes.smallSizedBoxHeight,
      ],
    );
  }
}
