import 'dart:ffi';

import 'package:flutter_p2p_communicator/flutter_p2p_communicator.dart';
import 'package:flutter_p2p_communicator/model/addr_model.dart';
import 'package:flutter_p2p_communicator/model/login_mode.dart';
import 'package:flutter_p2p_communicator/model/req_res_model.dart';
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

  Future<bool> _sendingData(dynamic model) async {
    final id = await FlutterP2pCommunicator.sendRequest(
        info: P2PReqResNodeModel(name: P2PReqResNodeNames.login, body: model.toJson()));
    print("P2PCommunicator: sending data start $id");
    return await p2pState.trackRequest(id);
    print("P2PCommunicator: sending data finish $id");
  }

  Future<bool> _connect(P2PAddrModel info) async {
    bool _connected = false;

    final id = await FlutterP2pCommunicator.sendRequest(
        info: P2PReqResNodeModel(name: P2PReqResNodeNames.connect, body: info.toJson()));
    print("P2PCommunicator: sending connect start $id");

    await p2pState.trackRequest(id);
    print("P2PCommunicator: sending connect finish $id");

    _connected = (p2pState.status[id]?.value == true);

    return _connected;
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

    String hexSDP = sdp.getHex();

    var connected = false;
    if (remotePeerId != null) {
      print("ADDRESS IS : ${p2pState.address.value}");
      connected = await _connect(P2PAddrModel(id: remotePeerId, addrs: p2pState.address.value));
    }

    final loginModel = P2PLoginBodyModel(
      // if connected is true then we need to send the remote peer id as well
      info: connected
          ? P2PTransferModel(
              localCoreID: localCoreId,
              remotePeerID: remotePeerId,
              remoteCoreID: remoteCoreId,
            )
          : P2PTransferModel(
              localCoreID: localCoreId,
              remoteCoreID: remoteCoreId,
            ),
      payload: P2PLoginPayloadModel(session: hexSDP),
    );
    return await _sendingData(loginModel);
  }
}
