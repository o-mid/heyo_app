import 'package:get/get.dart';
import 'package:heyo/app/modules/home/controllers/data_request_dialog.dart';

class HomeController extends GetxController {
  final tabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  void changeTabIndex(int index) {
    if (index == dataRequestTabIndex) {
      dataRequestDialog(Get.context!);
    } else {
      tabIndex.value = index;
    }
  }
}
const int dataRequestTabIndex = 2;
