import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/widgets/expandable_bottom_sheet/expandable_bottom_sheet_widget.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';

import '../controllers/share_location_controller.dart';

class ShareLocationDefaultBottomSheet extends StatelessWidget {
  final VoidCallback onShareLive;
  const ShareLocationDefaultBottomSheet({
    Key? key,
    required this.onShareLive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ShareLocationController>();
    return LayoutBuilder(builder: (context, constraints) {
      return ExpandableBottomSheet(
        expandedHeight: constraints.maxHeight * 0.55,
        horizontalMargin: 0,
        expandedBackColor: COLORS.kWhiteColor,
        bottomSheetBody: Container(
          width: 40.w,
          height: 3.h,
          color: const Color(0xffd2d2d2),
        ),
        expandedBody: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r).copyWith(
              bottomLeft: Radius.zero,
              bottomRight: Radius.zero,
            ),
          ),
          child: SingleChildScrollView(
            /// This is for preventing overflow error when bottom sheet size is small
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: 24.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8.r),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: onShareLive,
                      child: Row(
                        children: [
                          Container(
                            width: 40.w,
                            height: 40.w,
                            padding: EdgeInsets.all(10.w),
                            decoration: const BoxDecoration(
                              color: COLORS.kGreenMainColor,
                              shape: BoxShape.circle,
                            ),
                            child: Assets.svg.liveLocation.svg(
                              color: COLORS.kWhiteColor,
                            ),
                          ),
                          CustomSizes.mediumSizedBoxWidth,
                          Text(
                            LocaleKeys.shareLocationPage_bottomSheet_shareLiveLocation.tr,
                            style: TEXTSTYLES.kLinkBig.copyWith(color: COLORS.kDarkBlueColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                CustomSizes.mediumSizedBoxHeight,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8.r),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: controller.sendCurrentLocation,
                      child: Row(
                        children: [
                          Container(
                            width: 40.w,
                            height: 40.w,
                            padding: EdgeInsets.all(10.w),
                            decoration: const BoxDecoration(
                              color: COLORS.kBlueLightColor,
                              shape: BoxShape.circle,
                            ),
                            child: Assets.svg.target.svg(
                              color: COLORS.kDarkBlueColor,
                            ),
                          ),
                          CustomSizes.mediumSizedBoxWidth,
                          Expanded(
                            child: Text(
                              LocaleKeys.shareLocationPage_bottomSheet_sendPickerLocation.tr,
                              style: TEXTSTYLES.kLinkBig.copyWith(color: COLORS.kDarkBlueColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                const Divider(
                  color: COLORS.kPinCodeDeactivateColor,
                  thickness: 1,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
