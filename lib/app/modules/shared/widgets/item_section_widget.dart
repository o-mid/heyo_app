import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/constants/colors.dart';
import '../utils/constants/textStyles.dart';
import '../utils/screen-utils/sizing/custom_sizes.dart';

class ItemSectionWidget extends StatelessWidget {
  const ItemSectionWidget({
    Key? key,
    required this.title,
    required this.icon,
    this.iconBackgroundColor,
    this.subtitle,
    this.trailing = const SizedBox(),
    required this.onTap,
  }) : super(key: key);
  final String title;

  final Widget icon;

  final Color? iconBackgroundColor;

  final String? subtitle;

  final Widget trailing;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
        margin: EdgeInsets.symmetric(horizontal: 10.w),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: iconBackgroundColor,
              ),
              child: icon,
            ),
            CustomSizes.mediumSizedBoxWidth,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TEXTSTYLES.kLinkBig.copyWith(color: COLORS.kDarkBlueColor),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: TEXTSTYLES.kBodySmall.copyWith(color: COLORS.kTextSoftBlueColor),
                    ),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}
