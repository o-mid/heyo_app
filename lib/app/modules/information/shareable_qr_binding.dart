import 'package:get/get.dart';
import 'package:heyo/app/modules/information/get_share_info.dart';
import 'package:heyo/app/modules/information/shareable_qr_controller.dart';
import 'package:heyo/app/modules/shared/bindings/global_bindings.dart';

class ShareableQRBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ShareableQRController(
      qrInfo: QRInfo(accountInfoRepo: Get.find(), p2pState: Get.find()),
    ));
  }
}
