import 'package:get/get.dart';

import '../controllers/share_location_controller.dart';

class ShareLocationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShareLocationController>(
      () => ShareLocationController(),
    );
  }
}
