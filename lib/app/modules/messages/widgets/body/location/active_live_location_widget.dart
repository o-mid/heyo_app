import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/controllers/messages_controller.dart';
import 'package:heyo/app/modules/messages/data/models/messages/live_location_message_model.dart';
import 'package:heyo/app/modules/messages/widgets/body/location/base_location_message_widget.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:heyo/app/modules/shared/widgets/custom_button.dart';
import 'package:heyo/generated/locales.g.dart';

class ActiveLiveLocationWidget extends StatefulWidget {
  final LiveLocationMessageModel message;
  final VoidCallback onDone;
  const ActiveLiveLocationWidget({
    Key? key,
    required this.message,
    required this.onDone,
  }) : super(key: key);

  @override
  State<ActiveLiveLocationWidget> createState() => _ActiveLiveLocationState();
}

class _ActiveLiveLocationState extends State<ActiveLiveLocationWidget> {
  late double latitude;
  late double longitude;

  late StreamSubscription positionStream;
  late Timer timer;

  late MessagesController controller;

  bool isMapReady = false;

  @override
  void initState() {
    super.initState();

    controller = Get.find<MessagesController>();

    latitude = widget.message.latitude;
    longitude = widget.message.longitude;

    positionStream = Geolocator.getPositionStream().listen((position) {
      if (!isMapReady) {
        return;
      }
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
      });
    });

    /// This is for updating remaining time
    timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (DateTime.now().isAfter(widget.message.endTime)) {
        widget.onDone();
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    positionStream.cancel();
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseLocationMessageWidget(
      title: LocaleKeys.MessagesPage_sharingLiveLocation.tr,
      subtitle: _durationToHourMinutes(widget.message.endTime.difference(DateTime.now())),
      latitude: latitude,
      longitude: longitude,
      includeLeading: true,
      actionButton: widget.message.isFromMe
          ? Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: CustomButton(
                title: LocaleKeys.MessagesPage_stopSharing.tr,
                backgroundColor: COLORS.kGreenLighterColor,
                textStyle: TEXTSTYLES.kLinkBig.copyWith(color: COLORS.kGreenMainColor),
                onTap: () => controller.stopSharingLiveLocation(widget.message),
              ),
            )
          : null,
      onMapIsReady: () => isMapReady = true,
    );
  }

  String _durationToHourMinutes(Duration duration) {
    var minutes = duration.inMinutes;
    final hours = duration.inMinutes ~/ 60;
    minutes %= 60;

    if (hours == 0 && minutes == 0) {
      return LocaleKeys.MessagesPage_liveShareRemainingTime.trParams(
        {"time": LocaleKeys.MessagesPage_liveShareLessThanMinute.tr},
      );
    }

    String durationString = "";

    if (hours > 0) {
      durationString += LocaleKeys.MessagesPage_liveShareRemainingHour.trPluralParams(
        LocaleKeys.MessagesPage_liveShareRemainingHours,
        hours,
        {"count": hours.toString()},
      );
    }

    durationString +=
        durationString += LocaleKeys.MessagesPage_liveShareRemainingMinute.trPluralParams(
      LocaleKeys.MessagesPage_liveShareRemainingMinutes,
      minutes,
      {"count": minutes.toString()},
    );

    return LocaleKeys.MessagesPage_liveShareRemainingTime.trParams(
      {"time": durationString},
    );
  }
}
