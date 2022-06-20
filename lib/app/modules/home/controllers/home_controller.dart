import 'package:get/get.dart';
import 'package:heyo/app/modules/call_controller/call_state.dart';
import 'package:heyo/app/modules/home/controllers/data_request_dialog.dart';
import 'package:heyo/app/modules/p2p_node/p2p_state.dart';
import 'package:heyo/app/routes/app_pages.dart';
import 'package:heyo/app/modules/shared/data/models/incoming_call_view_arguments.dart';

class HomeController extends GetxController {
  final tabIndex = 0.obs;
  final P2PState p2pState;

  HomeController({required this.p2pState});

  @override
  void onInit() {
    super.onInit();
    p2pState.callState.listen((state) {
      if (state is CallReceivedState) {
        Get.toNamed(Routes.INCOMING_CALL,
            arguments: IncomingCallViewArguments(
                session: state.session,
                remoteCoreId: state.remoteCoreId,
                remotePeerId: state.remotePeerId));
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
