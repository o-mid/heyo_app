import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/widgets/qr_scan_view.dart';
import 'package:heyo/generated/locales.g.dart';

void openQrScannerBottomSheet(Function(String?) onDetect) {
  Get.bottomSheet(
    FractionallySizedBox(
      heightFactor: 1,
      child: QrScanView(
        title: LocaleKeys.newChat_newChatAppBar.tr,
        hasBackButton: true,
        onDetect: onDetect,
        subtitle: '',
      ),
    ),
    isScrollControlled: true,
  );
}
