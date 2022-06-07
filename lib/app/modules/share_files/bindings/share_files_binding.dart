import 'package:get/get.dart';

import '../controllers/share_files_controller.dart';

class ShareFilesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShareFilesController>(
      () => ShareFilesController(),
    );
  }
}
