import 'package:get/get.dart';
import 'package:heyo/app/modules/call_controller/call_state.dart';
import 'package:heyo/app/modules/home/controllers/data_request_dialog.dart';
import 'package:heyo/app/modules/p2p_node/p2p_state.dart';
import 'package:heyo/app/modules/call_controller/call_controller.dart';

class HomeController extends GetxController {
  final tabIndex = 0.obs;
  final P2PState p2pState;
  final CallConnectionController callController;

  HomeController({required this.p2pState, required this.callController});

  @override
  void onInit() {
    super.onInit();
    p2pState.callState.listen((p0) {
      if (p0 is CallReceivedState) {
        //TODO show user incomingCall page
        callController.acceptCall(p0.session, p0.eventId);
      }
    });
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
