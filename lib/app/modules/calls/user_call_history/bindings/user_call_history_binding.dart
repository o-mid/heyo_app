import 'package:get/get.dart';

import '../controllers/user_call_history_controller.dart';

class UserCallHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserCallHistoryController>(
      () => UserCallHistoryController(),
    );
  }
}
