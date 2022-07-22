import 'package:flutter_p2p_communicator/model/req_res_model.dart';
import 'package:get/get.dart';

enum P2P_STATUS { ERROR, IN_PROGRESS, SUCCESS, NONE }

class P2PState extends GetxController {
  final loginState = P2P_STATUS.NONE.obs;
  final candidate = "".obs;

  final currentCallId = "".obs;
  final endedCallIds = [].obs;
  final recordedCallIds = [];
  final address = <String>[].obs;
  final peerId = "".obs;
  final advertise = false.obs;
  List<P2PReqResNodeModel> responses = [];

  void reset() {
    loginState.value = P2P_STATUS.NONE;
    address.value = [];
    peerId.value = "";
    candidate.value = "";
  }
}
