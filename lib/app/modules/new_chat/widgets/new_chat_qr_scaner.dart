import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/generated/locales.g.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'qr_scan_view.dart';

void openQrScanerBottomSheet(Function(QRViewController) qrController) {
  Get.bottomSheet(
      FractionallySizedBox(
        heightFactor: 1,
        child: QrScanView(
          title: LocaleKeys.newChat_newChatAppBar.tr,
          hasBackButton: true,
          onQRViewCreated: qrController,
          subtitle: '',
        ),
      ),
      isScrollControlled: true);
}
