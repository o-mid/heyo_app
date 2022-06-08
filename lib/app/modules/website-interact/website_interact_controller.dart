import 'package:get/get.dart';
import 'package:heyo/app/modules/p2p_node/login.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class WebsiteInteractController extends GetxController {
  MobileScannerController? qrController;
  final Login login = Get.find<Login>();
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

  handleScannedVal(String? barcodeValue) {
    print("qr invoked: $barcodeValue");
    login.execute(barcodeValue);

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
}
