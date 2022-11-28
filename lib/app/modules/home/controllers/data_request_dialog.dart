import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/widgets/bottom_sheet.dart';
import 'package:heyo/app/routes/app_pages.dart';

import '../../new_chat/data/models/new_chat_view_arguments_model.dart';

void dataRequestDialog(BuildContext context) {
  Get.bottomSheet(
    HeyoBottomSheetContainer(
      children: [
        ListTile(
          onTap: () {
            Get.toNamed(Routes.SHREABLE_QR);
          },
          title: const Text("Share Info"),
        ),
        ListTile(
          onTap: () {
            Get.toNamed(
              Routes.NEW_CHAT,
              arguments: NewChatArgumentsModel(
                openQrScanner: true,
              ),
            );
          },
          title: const Text("Scan QR"),
        )
      ],
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
