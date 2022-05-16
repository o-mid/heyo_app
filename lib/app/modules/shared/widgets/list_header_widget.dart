import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';

import '../utils/screen-utils/sizing/custom_sizes.dart';

class ListHeaderWidget extends StatelessWidget {
  const ListHeaderWidget({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomSizes.mediumSizedBoxHeight,
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
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
            )
          ],
        ),
        CustomSizes.largeSizedBoxHeight
      ],
    );
  }
}
