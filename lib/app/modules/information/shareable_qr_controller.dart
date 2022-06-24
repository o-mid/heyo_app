import 'package:get/get.dart';
import 'package:heyo/app/modules/information/get_share_info.dart';

class ShareableQRController extends GetxController {
  final count = 0.obs;
  final QRInfo qrInfo;

  RxString shareableQr = "".obs;
  Rx<String?> coreId = "".obs;

  ShareableQRController({required this.qrInfo});

  @override
  void onInit() async {
    super.onInit();
    shareableQr.value = (await qrInfo.getSharableQr());
    coreId.value = (await qrInfo.getCoreId());
  }
}
