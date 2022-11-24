import 'package:flutter_p2p_communicator/model/req_res_model.dart';
import 'package:get/get.dart';

class P2PState extends GetxController {
  final address = <String>[].obs;
  final peerId = "".obs;
  final advertise = false.obs;
  List<P2PReqResNodeModel> responses = [];
  Map<String, Rxn<bool>> status = {};

  Future<bool> trackRequest(String id) async {
    print("P2PCommunicator: $id start tracking request");
    status[id] ??= Rxn();
    var requestSucceeded = false;
    int trackingTimer = 60;
    int timer = 0;

    await Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      timer++;
      if (timer > trackingTimer) {
        return false;
      }

      if (status[id]?.value == null) {
        print("P2PCommunicator: $id : tracking request : no response");
        return true;
      }
      if (status[id]!.value == true) {
        print("P2PCommunicator: $id : tracking request : response received : success");
        requestSucceeded = true;
        return false;
      } else {
        print("P2PCommunicator: $id : tracking request : response received : failed");
        requestSucceeded = false;
        return false;
      }
    });
    return requestSucceeded;
  }

  void reset() {
    address.value = [];
    peerId.value = "";
  }
}
