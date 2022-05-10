import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/data/models/messages/location_message_model.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/fonts.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/generated/locales.g.dart';

class LocationMessageWidget extends StatefulWidget {
  final LocationMessageModel message;
  const LocationMessageWidget({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  State<LocationMessageWidget> createState() => _LocationMessageWidgetState();
}

class _LocationMessageWidgetState extends State<LocationMessageWidget> {
  late MapController controller;
  @override
  void initState() {
    super.initState();
    final geoPoint =
        GeoPoint(latitude: widget.message.latitude, longitude: widget.message.longitude);
    controller = MapController(
      initMapWithUserPosition: false,
      initPosition: geoPoint,
    );
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
              staticPoints: [
                StaticPositionGeoPoint(
                    "0",
                    const MarkerIcon(
                      icon: Icon(
                        Icons.location_on,
                        color: COLORS.kStatesErrorColor,
                        size: 72,
                      ),
                    ),
                    [
                      GeoPoint(
                          latitude: widget.message.latitude, longitude: widget.message.longitude)
                    ])
              ],
              controller: controller,
              initZoom: 16,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.MessagesPage_sharedLocation.tr,
                  style: TEXTSTYLES.kChatText.copyWith(
                    color: COLORS.kDarkBlueColor,
                    fontWeight: FONTS.SemiBold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  widget.message.address,
                  style: TEXTSTYLES.kChatText.copyWith(
                    color: COLORS.kTextBlueColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
