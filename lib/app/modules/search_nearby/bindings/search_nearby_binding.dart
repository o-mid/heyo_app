import 'package:get/get.dart';

import '../controllers/search_nearby_controller.dart';

class SearchNearbyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchNearbyController>(
      () => SearchNearbyController(),
    );
  }
}
