import 'dart:ffi';

import 'package:flutter_p2p_communicator/flutter_p2p_communicator.dart';
import 'package:flutter_p2p_communicator/model/addr_model.dart';
import 'package:flutter_p2p_communicator/model/login_mode.dart';
import 'package:flutter_p2p_communicator/model/req_res_model.dart';
import 'package:flutter_p2p_communicator/model/signaling_model.dart';
import 'package:flutter_p2p_communicator/model/transfer_model.dart';
import 'package:collection/src/iterable_extensions.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/utils/extensions/string.extension.dart';

import 'data/account/account_info.dart';
import 'p2p_state.dart';

class P2PCommunicator {
  final P2PState p2pState;
  final AccountInfo accountInfo;

  P2PCommunicator({required this.p2pState, required this.accountInfo});

  Future<bool> _sendingData(SignalingModel model) async {
    final id = await FlutterP2pCommunicator.sendRequest(
        info: P2PReqResNodeModel(
            name: P2PReqResNodeNames.signaling, body: model.toJson(),),);
    print("P2PCommunicator: sending data start $id");
    return await p2pState.trackRequest(id);
    print("P2PCommunicator: sending data finish $id");
  }


  Future<bool> sendSDP(String sdp, String remoteCoreId, String? remotePeerId) async {
    // seding sdp to remote peer prosess
    // 1. get local core id
    // 2. get the sep hex
    // 3. send connection request if remote peer id is not null and wait for connection response
    // 4. create p2p login model
    // 5. send login request and track the Request

    final localCoreId = await accountInfo.getCoreId();
    if (localCoreId == null) throw 'Core id is null!!';

    final hexSDP = sdp.getHex();

    final p2pSignalingObj = SignalingModel(
        info: P2PTransferModel(
          localCoreID: localCoreId,
          remoteCoreID: remoteCoreId,
          remotePeerID: remotePeerId,
        ),
        payload: SignalingPayloadModel(
            data:hexSDP,),);



    return _sendingData(p2pSignalingObj);
  }
}
