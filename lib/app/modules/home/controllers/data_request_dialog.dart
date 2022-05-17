import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/widgets/bottom_sheet.dart';
import 'package:heyo/app/routes/app_pages.dart';

void dataRequestDialog(BuildContext context){

  Get.bottomSheet(
    HeyoBottomSheetContainer(
      children: [ListTile(
        onTap: (){
          Get.toNamed(Routes.SHREABLE_QR);
        },
        title: Text("Share Info"),
      ), ListTile(onTap: (){
        Get.toNamed(Routes.SCAN_QR);
      },
      title: Text("Scan QR"),)],
    ),
    enterBottomSheetDuration: const Duration(milliseconds: 150),
    exitBottomSheetDuration: const Duration(milliseconds: 200),
    elevation: 8.0,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    backgroundColor: COLORS.kAppBackground,
  );
}