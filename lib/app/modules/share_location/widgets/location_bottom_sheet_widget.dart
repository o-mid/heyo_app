import 'package:flutter/material.dart';

import 'package:heyo/app/modules/shared/widgets/expandable_bottom_sheet/expandable_bottom_sheet_controller.dart';

import 'share_live_location_bottom_sheet.dart';
import 'share_location_default_bottom_sheet.dart';

class LocationBottomSheetWidget extends StatefulWidget {
  const LocationBottomSheetWidget({Key? key}) : super(key: key);

  @override
  State<LocationBottomSheetWidget> createState() => _LocationBottomSheetWidgetState();
}

class _LocationBottomSheetWidgetState extends State<LocationBottomSheetWidget> {
  bool showLiveBottomSheet = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        GestureDetector(
          onVerticalDragUpdate: DefaultBottomBarController.of(context).onDrag,
          onVerticalDragEnd: DefaultBottomBarController.of(context).onDragEnd,
          child: showLiveBottomSheet
              ? ShareLiveLocationBottomSheet(
                  onBack: () {
                    setState(() {
                      showLiveBottomSheet = false;
                    });
                  },
                )
              : ShareLocationDefaultBottomSheet(
                  onShareLive: () {
                    setState(() {
                      showLiveBottomSheet = true;
                    });
                  },
                ),
        ),
      ],
    );
  }
}
