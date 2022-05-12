import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/share_location/controllers/share_location_controller.dart';

import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/buttons/custom_button.dart';
import 'package:heyo/app/modules/shared/widgets/expandable_bottom_sheet/expandable_bottom_sheet_widget.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';

class ShareLiveLocationBottomSheet extends StatefulWidget {
  final VoidCallback onBack;
  const ShareLiveLocationBottomSheet({
    Key? key,
    required this.onBack,
  }) : super(key: key);

  @override
  State<ShareLiveLocationBottomSheet> createState() => _ShareLiveLocationBottomSheetState();
}

class _ShareLiveLocationBottomSheetState extends State<ShareLiveLocationBottomSheet> {
  int selected = 0;
  late String chatName;
  final shareDurations = [
    const Duration(minutes: 30),
    const Duration(hours: 1),
    const Duration(hours: 2),
  ];
  @override
  void initState() {
    super.initState();
    chatName = Get.find<ShareLocationController>().chatName;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return ExpandableBottomSheet(
        expandedHeight: constraints.maxHeight * 0.45,
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
                SizedBox(height: 34.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: widget.onBack,
                        child: const Icon(
                          Icons.arrow_back,
                          color: COLORS.kGreenMainColor,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          LocaleKeys.shareLocationPage_bottomSheet_shareLiveLocationWith.trParams(
                            {"name": chatName},
                          ),
                          style: TEXTSTYLES.kLinkBig.copyWith(color: COLORS.kDarkBlueColor),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 28.h),
                _buildShareDurations(),
                SizedBox(height: 24.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: CustomButton.primary(
                    title: LocaleKeys.shareLocationPage_bottomSheet_shareLiveLocation.tr,
                  ),
                ),
                SizedBox(height: 14.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Assets.svg.infoIcon.svg(color: COLORS.kTextBlueColor),
                      SizedBox(width: 18.w),
                      Expanded(
                        child: Text(
                          LocaleKeys.shareLocationPage_bottomSheet_locationAccessDisclaimer.tr,
                          style: TEXTSTYLES.kReactionNumber.copyWith(
                            height: 1.6,
                            color: COLORS.kTextBlueColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildShareDurations() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildDurationOption(
          text: LocaleKeys.shareLocationPage_bottomSheet_shareDurationMinutes.trParams(
            {
              "count": "30",
            },
          ).tr,
          index: 0,
        ),
        _buildDurationOption(
          text: LocaleKeys.shareLocationPage_bottomSheet_shareDurationHour.trPluralParams(
            LocaleKeys.shareLocationPage_bottomSheet_shareDurationHours,
            1,
            {
              "count": "1",
            },
          ).tr,
          index: 1,
        ),
        _buildDurationOption(
          text: LocaleKeys.shareLocationPage_bottomSheet_shareDurationHour.trPluralParams(
            LocaleKeys.shareLocationPage_bottomSheet_shareDurationHours,
            2,
            {
              "count": "2",
            },
          ).tr,
          index: 2,
        ),
      ],
    );
  }

  Widget _buildDurationOption({
    required String text,
    required int index,
  }) {
    final borderRadius = BorderRadius.circular(19.r);
    final isActive = index == selected;
    return Material(
      color: Colors.transparent,
      borderRadius: borderRadius,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          setState(() {
            selected = index;
          });
        },
        child: Ink(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            color: isActive ? COLORS.kGreenLighterColor : COLORS.kBrightBlueColor,
          ),
          child: Text(
            text,
            style: TEXTSTYLES.kLinkBig.copyWith(
              color: isActive ? COLORS.kGreenMainColor : COLORS.kDarkBlueColor,
            ),
          ),
        ),
      ),
    );
  }
}
