import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/new_chat/widgets/qr_scan_view.dart';
import 'package:heyo/app/modules/website-interact/website_interact_controller.dart';
import 'package:heyo/generated/locales.g.dart';

class WebsiteInteractView extends GetView<WebsiteInteractController> {
  const WebsiteInteractView({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: QrScanView(
        onDetect: controller.handleScannedVal,
        hasBackButton: true,
        subtitle: "",
        title: LocaleKeys.scanQrTitle.tr,
      ),
    );
  }
}
