import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:heyo/app/modules/information/shareable_qr_controller.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ShareableQrView extends GetView<ShareableQRController> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        color: COLORS.kAppBackground,
        padding: const EdgeInsets.all(24),
        child: Center(child: Column(
          children: [

            Obx(() {
              return QrImage(
                padding: const EdgeInsets.all(24),
                data: controller.shareableQr.value,
                version: QrVersions.auto,
                size: 241.0,
              );
            }),
            Padding(padding: const EdgeInsets.all(24),child: Obx((){
              return SelectableText('${controller.coreId.value}', style: TEXTSTYLES.kHeaderMedium.copyWith(
                color: COLORS.kBlackColor,
              ));
            }),)
          ],
        ),));
  }
}
