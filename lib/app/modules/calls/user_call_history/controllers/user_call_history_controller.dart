import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/shared/data/models/call_model.dart';

class UserCallHistoryController extends GetxController {
  final calls = <CallModel>[].obs;

  final count = 0.obs;
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
  void increment() => count.value++;
}
