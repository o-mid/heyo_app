import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/app/modules/shared/widgets/expandable_bottom_sheet/expandable_bottom_sheet_controller.dart';
import 'package:heyo/app/modules/shared/widgets/expandable_bottom_sheet/expandable_bottom_sheet_widget.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';

import '../controllers/share_location_controller.dart';

class ShareLocationView extends GetView<ShareLocationController> {
  const ShareLocationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.shareLocationPage_appBar.tr,
          style: TEXTSTYLES.kHeaderLarge.copyWith(color: COLORS.kWhiteColor),
        ),
        leading: IconButton(
          onPressed: Get.back,
          icon: const Icon(
            Icons.arrow_back,
            color: COLORS.kWhiteColor,
          ),
        ),
        centerTitle: false,
        automaticallyImplyLeading: true,
        backgroundColor: COLORS.kGreenMainColor,
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          children: [
            Stack(
              children: [
                Obx(() {
                  if (controller.controller != null) {
                    return OSMFlutter(
                      controller: controller.controller!,
                      initZoom: 16,
                      trackMyPosition: true,
                      onMapIsReady: (isReady) {
                        if (isReady) {
                          controller.updateCurrentAddress();
                        }
                      },
                      userLocationMarker: UserLocationMaker(
                        personMarker: const MarkerIcon(
                          icon: Icon(
                            Icons.location_history_rounded,
                            color: Colors.red,
                            size: 48,
                          ),
                        ),
                        directionArrowMarker: MarkerIcon(
                          iconWidget: Container(
                            width: 64,
                            height: 64,
                            decoration: const BoxDecoration(
                              color: COLORS.kMapBlue,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.double_arrow,
                              size: 48,
                              color: COLORS.kWhiteColor,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),
                Positioned(
                  top: 16.h,
                  right: 20.w,
                  child: GestureDetector(
                    onTap: () {
                      controller.controller?.enableTracking();
                    },
                    child: Container(
                      padding: EdgeInsets.all(9.w),
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: COLORS.kWhiteColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            offset: const Offset(0, 2),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      child: Assets.svg.gpsFixed.svg(color: COLORS.kMapBlue),
                    ),
                  ),
                ),
              ],
            ),
            const Positioned.fill(
              bottom: 0,
              child: DefaultBottomBarController(
                isInitiallyOpen: true,
                child: LocationBottomSheetWidget(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LocationBottomSheetWidget extends StatelessWidget {
  const LocationBottomSheetWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ShareLocationController>();
    return GestureDetector(
      onVerticalDragUpdate: DefaultBottomBarController.of(context).onDrag,
      onVerticalDragEnd: DefaultBottomBarController.of(context).onDragEnd,
      child: LayoutBuilder(builder: (context, constraints) {
        return ExpandableBottomSheet(
          expandedHeight: constraints.maxHeight * 0.55,
          horizontalMargin: 0,
          expandedBackColor: COLORS.kWhiteColor,
          bottomSheetBody: Container(
            padding: EdgeInsets.only(top: 3.h),
            width: 40.w,
            height: 0,
            color: const Color(0xffd2d2d2),
            child: Container(
              color: COLORS.kWhiteColor,
            ),
          ),
          expandedBody: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r).copyWith(
                bottomLeft: Radius.zero,
                bottomRight: Radius.zero,
              ),
            ),
            child: Column(
              // Todo: fix overflow error when expanding/collapsing
              children: [
                SizedBox(height: 24.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
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
                CustomSizes.mediumSizedBoxHeight,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              LocaleKeys.shareLocationPage_bottomSheet_sendCurrentLocation.tr,
                              style: TEXTSTYLES.kLinkBig.copyWith(color: COLORS.kDarkBlueColor),
                            ),
                            Obx(() {
                              return Text(
                                controller.currentAddress.value,
                                maxLines: 2,
                                style: TEXTSTYLES.kBodySmall.copyWith(color: COLORS.kTextBlueColor),
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
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
        );
      }),
    );
  }
}
