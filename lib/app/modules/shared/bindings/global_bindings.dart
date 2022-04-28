import 'package:get/get.dart';
import 'package:heyo/app/modules/chats/controllers/chats_controller.dart';
import 'package:heyo/app/modules/shared/data/controllers/audio_message_controller.dart';
import 'package:heyo/app/modules/shared/data/controllers/video_message_controller.dart';

class GlobalBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(ChatsController());
    Get.put(AudioMessageController());
    Get.put(VideoMessageController());
  }
}
