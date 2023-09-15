import 'package:get/get.dart';
import '../controllers/call_controller.dart';
import 'package:heyo/app/modules/calls/data/web_rtc_call_repository.dart';

class CallBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CallController>(
      () => CallController(
          callRepository: WebRTCCallRepository(callConnectionsHandler: Get.find())),
    );
  }
}
