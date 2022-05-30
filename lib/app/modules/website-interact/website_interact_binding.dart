import 'package:get/get.dart';
import 'package:heyo/app/modules/website-interact/website_interact_controller.dart';

class WebsiteInteractBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WebsiteInteractController>(
      () => WebsiteInteractController(),
    );
  }
}
