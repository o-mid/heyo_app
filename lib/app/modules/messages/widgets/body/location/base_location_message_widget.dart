import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/fonts.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/utils/screen-utils/sizing/custom_sizes.dart';
import 'package:heyo/generated/assets.gen.dart';

class BaseLocationMessageWidget extends StatefulWidget {
  final String title;
  final String subtitle;
  final double latitude;
  final double longitude;
  final MarkerIcon? markerIcon;
  final bool includeLeading;
  final Widget? actionButton;
  final VoidCallback? onMapIsReady;

  const BaseLocationMessageWidget({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.latitude,
    required this.longitude,
    this.markerIcon,
    this.includeLeading = false,
    this.actionButton,
    this.onMapIsReady,
  }) : super(key: key);

  @override
  State<BaseLocationMessageWidget> createState() => _BaseLocationMessageWidgetState();
}

class _BaseLocationMessageWidgetState extends State<BaseLocationMessageWidget> {
  final _zoomLevel = 16.0;
  late MapController controller;

  bool isMapReady = false;
  bool isMarkerLocked = false;
  final markerLockDuration = const Duration(milliseconds: 600);
  @override
  void initState() {
    super.initState();
    final geoPoint = GeoPoint(latitude: widget.latitude, longitude: widget.longitude);
    controller = MapController(
      initMapWithUserPosition: false,
      initPosition: geoPoint,
    );
  }

  @override
  void didUpdateWidget(covariant BaseLocationMessageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!isMapReady || isMarkerLocked) {
      return;
    }

    if (oldWidget.latitude != widget.latitude || oldWidget.longitude != widget.longitude) {
      isMarkerLocked = true;

      // Todo: animate this once following issue is resolved: https://github.com/liodali/osm_flutter/issues/258
      final oldPoint = GeoPoint(latitude: oldWidget.latitude, longitude: oldWidget.longitude);
      controller.removeMarker(oldPoint);

      final newPoint = GeoPoint(latitude: widget.latitude, longitude: widget.longitude);
      controller.addMarker(newPoint, markerIcon: widget.markerIcon ?? _defaultMarkerIcon());

      controller.goToLocation(newPoint);
      controller.setZoom(zoomLevel: _zoomLevel);

      Future.delayed(markerLockDuration, () => isMarkerLocked = false);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: COLORS.kPinCodeDeactivateColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 166,
            child: OSMFlutter(
              controller: controller,
              initZoom: _zoomLevel,
              onMapIsReady: (isReady) {
                isMapReady = isReady;
                if (!isReady) {
                  return;
                }
                if (widget.onMapIsReady != null) {
                  widget.onMapIsReady!();
                }

                final geoPoint = GeoPoint(
                  latitude: widget.latitude,
                  longitude: widget.longitude,
                );

                controller.addMarker(
                  geoPoint,
                  markerIcon: widget.markerIcon ?? _defaultMarkerIcon(),
                );
              },
            ),
          ),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.includeLeading)
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w).copyWith(right: 0),
                    child: Assets.svg.liveLocationActive.svg(
                      color: COLORS.kGreenMainColor,
                    ),
                  ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: TEXTSTYLES.kChatText.copyWith(
                            color: COLORS.kDarkBlueColor,
                            fontWeight: FONTS.SemiBold,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          widget.subtitle,
                          style: TEXTSTYLES.kChatText.copyWith(
                            color: COLORS.kTextBlueColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (widget.actionButton != null) ...[
            widget.actionButton!,
            CustomSizes.smallSizedBoxHeight,
          ]
        ],
      ),
    );
  }

  MarkerIcon _defaultMarkerIcon() {
    return MarkerIcon(
      iconWidget: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: COLORS.kGreenMainColor,
          shape: BoxShape.circle,
          border: Border.all(
            color: COLORS.kWhiteColor,
            width: 5.w,
          ),
        ),
        child: Assets.svg.locationFilled.svg(width: 50.w, height: 50.w),
      ),
    );
  }
}
