import 'package:get/get.dart';
import 'package:heyo/app/modules/home/controllers/data_request_dialog.dart';
import 'package:heyo/app/modules/p2p_node/p2p_state.dart';
import 'package:heyo/app/modules/web-rtc/signaling.dart';

class HomeController extends GetxController {
  final tabIndex = 0.obs;
  final P2PState p2pState;
  final Signaling signaling;

  HomeController({required this.p2pState, required this.signaling});


  void changeTabIndex(int index) {
    if (index == dataRequestTabIndex) {
      dataRequestDialog(Get.context!);
    } else {
      tabIndex.value = index;
    }
  }
}

const int dataRequestTabIndex = 2;
