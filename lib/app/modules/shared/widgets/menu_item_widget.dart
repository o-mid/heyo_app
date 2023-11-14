import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';

class MenuItem extends StatelessWidget {
  MenuItem(
      {required this.onTap,
      this.iconBackgroundColor,
      required this.icon,
      required this.title,
      this.subtitle,
      this.trailing,
      super.key});

  Function() onTap;
  Color? iconBackgroundColor;
  Widget icon;
  Widget? trailing;
  String? subtitle;
  String title;

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
                    style: TEXTSTYLES.kLinkBig
                        .copyWith(color: COLORS.kDarkBlueColor),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: TEXTSTYLES.kBodySmall
                          .copyWith(color: COLORS.kTextSoftBlueColor),
                    ),
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
