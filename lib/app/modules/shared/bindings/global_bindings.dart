import 'package:get/get.dart';
import 'package:heyo/app/modules/chats/controllers/chats_controller.dart';

class GlobalBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(ChatsController());
  }
}
