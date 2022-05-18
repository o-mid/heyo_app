import 'package:get/get.dart';
import 'package:heyo/app/modules/information/get_share_info.dart';

class ShareableQRController extends GetxController {
  final count = 0.obs;
  final QRInfo _qrInfo = Get.find<QRInfo>();
  late RxString shareableQr;

  @override
  void onInit() async {
    super.onInit();
    shareableQr = (await _qrInfo.getSharableQr()).obs;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  void increment() => count.value++;
}
