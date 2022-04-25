import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrScanView extends StatelessWidget {
  final String title;
  final bool hasBackButton;
  final String subtitle;
  final Function(QRViewController) onQRViewCreated;
  final Function()? closeButtonOnClick;

  QrScanView(
      {required this.title,
      required this.subtitle,
      required this.onQRViewCreated,
      this.hasBackButton = false,
      this.closeButtonOnClick = null});

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QRKey');
  @override
  Widget build(BuildContext context) {
    var scanArea = Get.width < 400 || Get.height < 400 ? 220.0 : 300.0;
    return Stack(
      children: [
        QRView(
          key: qrKey,
          onQRViewCreated: onQRViewCreated,
          overlay: QrScannerOverlayShape(
              borderWidth: 2,
              borderColor: COLORS.kWhiteColor,
              borderRadius: 20,
              borderLength: 40,
              cutOutSize: scanArea),
        ),
        Align(
          alignment: Alignment.center,
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  hasBackButton
                      ? Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                                color: Colors.white),
                            onPressed: closeButtonOnClick ?? () => Get.back(),
                          ),
                        )
                      : const SizedBox(),
                  Text(
                    title,
                    style: TEXTSTYLES.kHeaderLarge
                        .copyWith(color: COLORS.kWhiteColor),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              SizedBox(
                width: 300.0,
                child: Text(
                  subtitle,
                  style: TEXTSTYLES.kBodyBasic,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
