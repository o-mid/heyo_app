import 'package:flutter_p2p_communicator/flutter_p2p_communicator.dart';
import 'package:flutter_p2p_communicator/model/addr_model.dart';
import 'package:flutter_p2p_communicator/model/req_res_model.dart';
import 'package:flutter_p2p_communicator/utils/constants.dart';
import 'package:heyo/app/modules/p2p_node/data/account/account_info.dart';
import 'package:heyo/app/modules/p2p_node/p2p_node_request.dart';
import 'package:heyo/app/modules/p2p_node/p2p_node_response.dart';
import 'package:heyo/app/modules/p2p_node/p2p_state.dart';
import 'package:web3dart/crypto.dart';
import 'package:flutter_bip39/bip39.dart';

class P2PNode {
  final AccountInfo accountInfo;
  final P2PNodeResponseStream p2pNodeResponseStream;
  final P2PNodeRequestStream p2pNodeRequestStream;
  final P2PState p2pState;

  P2PNode(
      {required this.accountInfo,
      required this.p2pNodeRequestStream,
      required this.p2pNodeResponseStream,
      required this.p2pState});

  _setUpP2PNode() async {
    _listenToStreams();
    _startP2PNode();
  }

  _startP2PNode() async {
    if (await accountInfo.getCoreId() == null) {
      await accountInfo.createAccount();
    }

    String? _peerSeed = await accountInfo.getP2PSecret();
    if (_peerSeed == null) {
      _peerSeed = bytesToHex(mnemonicToSeed(generateMnemonic()).aesKeySeed);
      await accountInfo.setP2PSecret(_peerSeed);
    }
    await FlutterP2pCommunicator.startNode(
      peerSeed: _peerSeed,networkId: "1"
    );

    final _privateKey = await accountInfo.getPrivateKey();
    final _privToAdd = P2PReqResNodeModel(
        name: P2PReqResNodeNames.addCoreID, body: {"privKey": _privateKey});

    await FlutterP2pCommunicator.sendRequest(info: _privToAdd);

    await Future.forEach(P2P_Nodes, (P2PAddrModel element) async {
      final _info = P2PReqResNodeModel(
          name: P2PReqResNodeNames.connect, body: element.toJson());
      await FlutterP2pCommunicator.sendRequest(info: _info);
    });
  }

  _listenToStreams() {
    p2pNodeResponseStream.setUp();
    p2pNodeRequestStream.setUp();
  }

  void stop() {
    _stopP2PNode();
    p2pState.reset();
    p2pNodeRequestStream.reset();
    p2pNodeResponseStream.reset();
    //TODO reset values
  }

  _stopP2PNode() async {
    await FlutterP2pCommunicator.stopNode();
  }

  void restart() {
    _setUpP2PNode();
  }
}
