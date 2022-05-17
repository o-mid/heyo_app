import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:heyo/app/modules/information/shareable_qr_controller.dart';
import 'package:heyo/app/modules/p2p_node/data/account/account_info.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ShareableQrView extends GetView<ShareableQRController>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      color: COLORS.kAppBackground,
      child: Center(
        child: Obx(() {
          return QrImage(
            padding: const EdgeInsets.all(25),
            data: controller.shareableQr.value,
            version: QrVersions.auto,
            size: 241.0,
          );
        }),
      )
    );
  }

}