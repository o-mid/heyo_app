import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/fonts.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/generated/assets.gen.dart';

class ModifiedAlertDialog extends StatelessWidget {
  final Widget alertContent;
  final double? padding;
  final Function? onClose;
  final bool hideCloseSign;
  ModifiedAlertDialog(
      {Key? key,
      this.onClose,
      required this.alertContent,
      this.padding,
      this.hideCloseSign = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      child: WillPopScope(
        onWillPop: () async {
          if (onClose != null) onClose!();
          return Future.value(!hideCloseSign);
        },
        child: AlertDialog(
          insetPadding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          titlePadding: EdgeInsets.zero,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: 40.w),
              Visibility(
                visible: !hideCloseSign,
                child: removeSign(onPressed: () {
                  if (onClose != null)
                    onClose!();
                  else
                    Get.back();
                }),
              ),
            ],
          ),
          contentPadding: EdgeInsets.zero,
          content: Wrap(
            children: [
              Container(
                width: Get.width - 40.0,
              ),
              Padding(
                padding: EdgeInsets.only(
                  right: padding ?? 20.0.w,
                  left: padding ?? 20.0.w,
                  bottom: 40.0.w,
                ),
                child: alertContent,
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget removeSign({required Function onPressed, bool hasError = false}) {
  return InkWell(
    borderRadius: BorderRadius.circular(100),
    onTap: () {
      onPressed();
    },
    child: Padding(
      padding: const EdgeInsets.all(8),
      child: Assets.svg.closeSign.svg(
        width: 20.w,
        height: 20.w,
      ),
    ),
  );
}

class DefaultAlertDialogContent extends StatelessWidget {
  /// Icon shown on top of dialog
  final Widget indicatorIcon;
  final Color indicatorBackgroundColor;
  final String title;
  final String subtitle;
  final List<Widget> buttons;
  const DefaultAlertDialogContent({
    Key? key,
    required this.indicatorIcon,
    this.indicatorBackgroundColor = Colors.transparent,
    required this.title,
    required this.subtitle,
    required this.buttons,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Container(
            width: 64.w,
            height: 64.w,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: indicatorBackgroundColor,
              shape: BoxShape.circle,
            ),
            child: indicatorIcon,
          ),
          SizedBox(height: 24.w),
          Text(
            title,
            style:
                TEXTSTYLES.kHeaderLarge.copyWith(color: COLORS.kDarkBlueColor),
          ),
          CustomSizes.smallSizedBoxHeight,
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TEXTSTYLES.kLinkSmall.copyWith(
              fontWeight: FONTS.Regular,
              color: COLORS.kTextBlueColor,
            ),
          ),
          SizedBox(height: 24.w),
          ...buttons,
        ],
      ),
    );
  }
}
