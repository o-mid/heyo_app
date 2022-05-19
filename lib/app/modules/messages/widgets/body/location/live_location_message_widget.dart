import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/data/models/messages/live_location_message_model.dart';
import 'package:heyo/app/modules/messages/widgets/body/location/base_location_message_widget.dart';
import 'package:heyo/generated/locales.g.dart';
import 'package:intl/intl.dart';

import 'active_live_location_widget.dart';

class LiveLocationMessageWidget extends StatefulWidget {
  final LiveLocationMessageModel message;
  const LiveLocationMessageWidget({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  State<LiveLocationMessageWidget> createState() => _LiveLocationMessageWidgetState();
}

class _LiveLocationMessageWidgetState extends State<LiveLocationMessageWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.message.endTime.isBefore(DateTime.now())
        ? BaseLocationMessageWidget(
            title: widget.message.isFromMe
                ? LocaleKeys.MessagesPage_finishedLiveShareTitle.tr
                : LocaleKeys.MessagesPage_finishedLiveShareOtherTitle.trParams(
                    {'user': widget.message.senderName},
                  ),
            subtitle: LocaleKeys.MessagesPage_finishedLiveShareSubtitle.trParams(
              {
                "day": DateFormat('E').format(widget.message.endTime),
                "clock":
                    "${widget.message.endTime.hour}:${widget.message.endTime.minute.toString().padLeft(2, '0')}",
              },
            ),
            latitude: widget.message.latitude,
            longitude: widget.message.longitude,
          )
        : ActiveLiveLocationWidget(
            message: widget.message,
            onDone: () {
              setState(() {});
            },
          );
  }
}
