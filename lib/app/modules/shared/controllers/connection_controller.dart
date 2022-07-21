import 'package:get/state_manager.dart';

enum ConnectionStatus { connectionLost, updating, justConnected, online }

class ConnectionController extends GetxController {
  Rx<ConnectionStatus> currentConnectionStatus = ConnectionStatus.online.obs;
  @override
  void onInit() {
    // to see the demo of connection UI uncomment next line
    // demoConnectionUi();
    super.onInit();
  }

  // this is just a demo to show the demoConnection Ui
  // sets the diffrent stage of the connection every 2 secounds
  // remove after impliment the connection functinallity
  void demoConnectionUi() {
    Future.delayed(const Duration(seconds: 2), () {
      currentConnectionStatus.value = ConnectionStatus.connectionLost;
    })
        .whenComplete(() => Future.delayed(const Duration(seconds: 2), () {
              currentConnectionStatus.value = ConnectionStatus.justConnected;
            }))
        .whenComplete(() => Future.delayed(const Duration(seconds: 2), () {
              currentConnectionStatus.value = ConnectionStatus.updating;
            }))
        .whenComplete(() => Future.delayed(const Duration(seconds: 2), () {
              currentConnectionStatus.value = ConnectionStatus.online;
            }));
  }

  void onClose() {
    super.onClose();
  }
}
