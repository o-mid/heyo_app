import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/state_manager.dart';
import 'package:heyo/app/modules/p2p_node/p2p_state.dart';

enum ConnectionStatus { connectionLost, updating, justConnected, online }

class ConnectionController extends GetxController {
  Rx<ConnectionStatus> currentConnectionStatus = ConnectionStatus.online.obs;

  final P2PState p2pState;

  ConnectionController({required this.p2pState});

  @override
  void onInit() {
    setPrimaryState();
    listenToStatus();

    super.onInit();
  }

  void setPrimaryState() async {
    ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();
    applyConnectivityStatus(p2pState.advertise.value, connectivityResult);
  }

  void listenToStatus() async {
    Connectivity().onConnectivityChanged.listen((connectivityResult) async {
      applyConnectivityStatus(p2pState.advertise.value, connectivityResult);
    });
    p2pState.advertise.listen((advertise) async {
      ConnectivityResult connectivityResult =
          await Connectivity().checkConnectivity();
      applyConnectivityStatus(advertise, connectivityResult);
    });
  }

  void applyConnectivityStatus(
      bool advertised, ConnectivityResult connectivityResult) async {
    if (connectivityResult == ConnectivityResult.none) {
      currentConnectionStatus.value = ConnectionStatus.connectionLost;
    } else if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      if (advertised) {
        currentConnectionStatus.value = ConnectionStatus.justConnected;
        await Future.delayed(const Duration(seconds: 2), () {
          currentConnectionStatus.value = ConnectionStatus.online;
        });
      } else {
        currentConnectionStatus.value = ConnectionStatus.updating;
      }
    }
  }
}
