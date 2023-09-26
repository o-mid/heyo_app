import 'package:flutter_p2p_communicator/model/req_res_model.dart';
import 'package:get/get.dart';

class P2PState extends GetxController {
  final address = <String>[].obs;
  final peerId = "".obs;
  final advertise = false.obs;
  List<P2PReqResNodeModel> responses = [];
  Map<String, Rxn<bool>> status = {};

// track the Requests and return true if the request was successful

  Future<bool> trackRequest(String id) async {
    print("P2PCommunicator: $id start tracking request");
    status[id] ??= Rxn();
    var requestSucceeded = false;
    int trackingTimer = 60;
    int timer = 0;

    // every second check status[id] if the request was successful or not and return true or false accordingly

    await Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      timer++;
      if (timer > trackingTimer) {
        return false;
      }

      if ((status[id] as Rxn<bool>)?.value == null) {
        //print("P2PCommunicator: $id : tracking request : no response");
        return true;
      }
      if ((status[id] as Rxn<bool>)!.value == true) {
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
    advertise.value = false;
    address.value = [];
    peerId.value = "";
  }
}
