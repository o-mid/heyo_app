import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/generated/assets.gen.dart';

class HeyoBottomSheetContainer extends StatelessWidget {
  final String? title;
  final List<Widget>? children;
  HeyoBottomSheetContainer({this.title, this.children});

  @override
  Widget build(BuildContext context) {
    var _children = this.children ?? [];
    return Wrap(
      children: [
        Container(
          height: 8,
        ),
        Center(
          child: Assets.svg.bottomSheetHandle.svg(),
        ),
        Container(
          height: 24,
        ),
        if ( title != null)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(title!,
                  style: TEXTSTYLES.kHeaderMedium.copyWith(color: COLORS.kTextBlueColor)),
            ),
          ),
        if ( title != null)
          const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Divider(
                height: 1,
                color: COLORS.kBlueLightColor,
              )),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _children,
        ),
        Container(
          height: 32,
        ),
      ],
    );
  }
}
