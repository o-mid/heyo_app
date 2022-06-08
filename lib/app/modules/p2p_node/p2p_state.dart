import 'package:flutter_p2p_communicator/model/req_res_model.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/call_controller/call_state.dart';

enum P2P_STATUS { ERROR, IN_PROGRESS, SUCCESS, NONE }

//enum CALL_STATUS { ON_GOING, ACCEPTING_CALL, NONE, ACCEPTED_CALL,CALL_RECEIVED }

class P2PState extends GetxController {
  final loginState = P2P_STATUS.NONE.obs;
  final callState = CallState.none().obs;
  final address = <String>[].obs;
  final peerId = "".obs;
  List<P2PReqResNodeModel> responses = [];

  void reset() {
    loginState.value = P2P_STATUS.NONE;
    address.value = [];
    peerId.value = "";
  }
}
