import 'package:get/get.dart';

import '../controllers/new_group_chat_controller.dart';

class NewGroupChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewGroupChatController>(
      () => NewGroupChatController(),
    );
  }
}
