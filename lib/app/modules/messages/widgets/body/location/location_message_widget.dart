import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/data/models/messages/location_message_model.dart';
import 'package:heyo/app/modules/messages/widgets/body/location/base_location_message_widget.dart';

import 'package:heyo/generated/locales.g.dart';

class LocationMessageWidget extends StatelessWidget {
  final LocationMessageModel message;
  const LocationMessageWidget({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseLocationMessageWidget(
      title: LocaleKeys.MessagesPage_sharedLocation.tr,
      subtitle: "${message.latitude} ${message.longitude}",
      latitude: message.latitude,
      longitude: message.longitude,
    );
  }
}
