import 'package:get/get.dart';
import 'package:heyo/app/modules/connection/domain/connection_contractor.dart';
import 'package:heyo/app/modules/home/controllers/data_request_dialog.dart';
import 'package:heyo/app/modules/home/data/repository/home_repository.dart';
import 'package:heyo/app/modules/p2p_node/p2p_state.dart';

class HomeController extends GetxController {
  final tabIndex = 0.obs;
  final P2PState p2pState;
  ConnectionContractor connectionContractor;
  HomeRepository homeRepository;

  HomeController({
    required this.p2pState,
    required this.connectionContractor,
    required this.homeRepository,
  });

  @override
  void onInit() {
    connectionContractor.start();
    super.onInit();
  }

  @override
  void onReady() {
    homeRepository.sendFCMToken();
    super.onReady();
  }

  void changeTabIndex(int index) {
    if (index == dataRequestTabIndex) {
      dataRequestDialog(Get.context!);
    } else {
      tabIndex.value = index;
    }
  }
}

const int dataRequestTabIndex = 2;
