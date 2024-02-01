import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/utils/constants/colors.dart';
import 'package:heyo/app/modules/shared/utils/constants/textStyles.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScanView extends StatefulWidget {
  final String title;
  final bool hasBackButton;
  final String subtitle;
  final Function(String?) onDetect;
  final Function()? closeButtonOnClick;

  const QrScanView({
    super.key,
    required this.onDetect,
    required this.title,
    required this.subtitle,
    this.hasBackButton = false,
    this.closeButtonOnClick,
  });

  @override
  State<QrScanView> createState() => _QrScanViewState();
}

class _QrScanViewState extends State<QrScanView> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QRKey');

  final scannerController = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MobileScanner(
          key: qrKey,
          onDetect: (barcode, args) {
            widget.onDetect(barcode.rawValue);
            HapticFeedback.mediumImpact();
          },
          controller: scannerController,
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
                  widget.hasBackButton
                      ? Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                            onPressed: widget.closeButtonOnClick ?? () => Get.back(),
                          ),
                        )
                      : const SizedBox(),
                  Text(
                    widget.title,
                    style: TEXTSTYLES.kHeaderLarge.copyWith(color: COLORS.kWhiteColor),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              SizedBox(
                width: 300.0,
                child: Text(
                  widget.subtitle,
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
