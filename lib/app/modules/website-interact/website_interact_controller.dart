import 'package:get/get.dart';
import 'package:heyo/app/modules/p2p_node/login.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class WebsiteInteractController extends GetxController {
  QRViewController? qrController;
  final Login login;

  WebsiteInteractController({required this.login});

  bool isBusy = false;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    qrController?.dispose();
  }

  handleScannedVal(QRViewController qrControllerDt) {
    print("qr invoked");
    if (qrController == null) {
      qrController = qrControllerDt;
      qrController?.scannedDataStream.listen((scanData) async {
        print('scannedData: $scanData');
        print('scannedData.code: ${scanData.code}');

        if (scanData.code == null) {
          return;
        }
        if (isBusy) {
          return;
        } else {
          qrController?.pauseCamera();

          isBusy = true;

          login.execute(scanData);

          /*Get.find<DeepLinkController>().doLogin(scanData.code!,
              Get.find<ProfileController>().chosenProfile.value.coreId,
              loginCanceled: () {
                Get.until((route) => route.isFirst);
              }, loginDone: () {
                Get.until((route) => route.isFirst);
              }, loginError: () async {
                Get.until((route) => route.isFirst);
                await Get.dialog(AlertDialogModified(
                  alertContent: UnsuccessfulP2P(
                    isLogin: true,
                  ),
                ));
              }, onClose: () {
                qrController?.resumeCamera();
                isBusy = false;
              });*/
        }
      });
    }
  }
}
