import 'package:get/get.dart';

import '../data/models/forward_massages_view_arguements_model..dart';

class ForwardMassagesController extends GetxController {
  //TODO: Implement ForwardMassagesController
  late ForwardMassagesArgumentsModel args;
  final count = 0.obs;
  @override
  void onInit() {
    args = Get.arguments as ForwardMassagesArgumentsModel;
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
  void increment() => count.value++;
}
