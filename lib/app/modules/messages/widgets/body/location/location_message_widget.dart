import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/data/models/messages/location_message_model.dart';
import 'package:heyo/app/modules/messages/widgets/body/location/base_location_message_widget.dart';

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
    final geoPoint = GeoPoint(
      latitude: widget.message.latitude,
      longitude: widget.message.longitude,
    );

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
    return BaseLocationMessageWidget(
      title: LocaleKeys.MessagesPage_sharedLocation.tr,
      subtitle: widget.message.address,
      latitude: widget.message.latitude,
      longitude: widget.message.longitude,
    );
  }
}
