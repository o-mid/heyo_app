import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:heyo/app/modules/share_location/widgets/location_bottom_sheet_widget.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/widgets/custom_copyright_osm_widget.dart';
import 'package:heyo/app/modules/shared/widgets/expandable_bottom_sheet/expandable_bottom_sheet_controller.dart';
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
                      osmOption: OSMOption(
                        zoomOption: ZoomOption(
                          initZoom: 16,
                        ),
                        isPicker: true,
                        userTrackingOption:
                            UserTrackingOption(enableTracking: true),
                        userLocationMarker: UserLocationMaker(
                          personMarker: MarkerIcon(
                            iconWidget: Assets.svg.locationFilled.svg(
                              color: COLORS.kDarkBlueColor,
                              width: 100.w,
                              height: 100.w,
                            ),
                          ),
                          directionArrowMarker: MarkerIcon(),
                        ),
                      ),
                      onMapIsReady: (isReady) {
                        if (isReady) {
                          controller.updateCurrentAddress();
                        }
                      },
                    );
                  }
                  return const SizedBox.shrink();
                }),
                Positioned(
                  top: 16.h,
                  right: 20.w,
                  child: GestureDetector(
                    onTap: () async {
                      final currentLocation =
                          await controller.controller?.myLocation();
                      if (currentLocation == null) {
                        return;
                      }
                      controller.controller?.goToLocation(currentLocation);
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
                Positioned(
                  top: 16.h,
                  left: 16.w,
                  child: const CustomCopyrightOSMWidget(),
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
