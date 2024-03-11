import 'package:flutter/material.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';

Future<void> bottomSheetWidget(BuildContext context, Widget child) async {
  await showModalBottomSheet<void>(
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
