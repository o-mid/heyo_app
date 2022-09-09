import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';

import '../controllers/media_view_controller.dart';

class MediaViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MediaViewController>(
      () => MediaViewController(photoViewController: PhotoViewScaleStateController()),
    );
  }
}
