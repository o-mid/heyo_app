import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/generated/assets.gen.dart';

class HeyoBottomSheetContainer extends StatelessWidget {
  final String? title;
  final List<Widget> children;
  const HeyoBottomSheetContainer({
    super.key,
    this.title,
    this.children = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          height: 8.h,
        ),
        Center(
          child: Assets.svg.bottomsheetHandle.svg(),
        ),
        Container(
          height: 24,
        ),
        if (title != null) ...[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(title!,
                  style: TEXTSTYLES.kHeaderMedium.copyWith(color: COLORS.kTextBlueColor)),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Divider(
              height: 1,
              color: COLORS.kBlueLightColor,
            ),
          ),
        ],
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: children,
        ),
        Container(
          height: 32,
        ),
      ],
    );
  }
}
