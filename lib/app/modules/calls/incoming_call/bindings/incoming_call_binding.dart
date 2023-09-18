import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/data/web_rtc_call_repository.dart';
import '../controllers/incoming_call_controller.dart';

class IncomingCallBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IncomingCallController>(
      () => IncomingCallController(
          callRepository: WebRTCCallRepository(callConnectionsHandler: Get.find())),
    );
  }
}
