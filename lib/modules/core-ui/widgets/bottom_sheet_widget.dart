import 'package:flutter/material.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';

void bottomSheetWidget(BuildContext context, Widget child) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: COLORS.kWhiteColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    builder: (BuildContext context) => child,
  );
}
