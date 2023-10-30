import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter_p2p_communicator/flutter_p2p_communicator.dart';
import 'package:flutter_p2p_communicator/model/addr_model.dart';
import 'package:flutter_p2p_communicator/model/delegate_auth_model.dart';
import 'package:flutter_p2p_communicator/model/req_res_model.dart';
import 'package:flutter_p2p_communicator/model/signaling_model.dart';
import 'package:flutter_p2p_communicator/model/transfer_model.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/data/repository/crypto_account/crypto_account_repo.dart';
import 'package:heyo/app/modules/shared/utils/extensions/string.extension.dart';

import 'p2p_state.dart';

class P2PCommunicator {
  final P2PState p2pState;
  final CryptoAccountRepository accountInfoRepo;

  P2PCommunicator({required this.p2pState, required this.accountInfoRepo});

  Future<bool> _sendingData(P2PReqResNodeModel model) async {
    final id = await FlutterP2pCommunicator.sendRequest(info: model);
    print('P2PCommunicator: sending data start $id');
    return p2pState.trackRequest(id);
    // print("P2PCommunicator: sending data finish $id");
  }

  Future<bool> sendSDP(
      String sdp, String remoteCoreId, String? remotePeerId) async {
    // seding sdp to remote peer prosess
    // 1. get local core id
    // 2. get the sep hex
    // 3. send connection request if remote peer id is not null and wait for connection response
    // 4. create p2p login model
    // 5. send login request and track the Request

    final localCoreId = await accountInfoRepo.getUserDefaultAddress();
    final hexSDP = sdp.getHex();
    final requestModel = P2PReqResNodeModel(
      name: P2PReqResNodeNames.signaling,
      body: SignalingModel(
        info: P2PTransferModel(
          localCoreID: localCoreId,
          delegateRemote: DelegateRemoteModel(
            remoteDelegatedCoreID: remoteCoreId,
            remoteDelegateName: DelegateName.heyo,
          ),
        ),
        payload: SignalingPayloadModel(
          data: hexSDP,
        ),
      ).toJson(),
    );

    return _sendingData(requestModel);
  }

}
