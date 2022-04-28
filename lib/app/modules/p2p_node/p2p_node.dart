import 'package:flutter_p2p_communicator/flutter_p2p_communicator.dart';
import 'package:heyo/app/modules/p2p_node/p2p_node_request.dart';
import 'package:heyo/app/modules/p2p_node/p2p_node_response.dart';
import 'package:heyo/app/modules/p2p_node/p2p_secret.dart';
import 'package:web3dart/crypto.dart';
import 'package:flutter_bip39/bip39.dart';

class P2PNode {
  final P2PSecret p2pSecret;
  final P2PNodeResponseStream p2pNodeResponseStream;
  final P2PNodeRequestStream p2pNodeRequestStream;

  P2PNode(
      {required this.p2pSecret,
      required this.p2pNodeRequestStream,
      required this.p2pNodeResponseStream});

  _setUpP2PNode() async {
    _listenToStreams();
    _startP2PNode();
  }

  _startP2PNode() async {
    String? _peerSeed = await p2pSecret.getP2PSecret();
    if (_peerSeed == null) {
      _peerSeed = bytesToHex(mnemonicToSeed(generateMnemonic()).aesKeySeed);
      await p2pSecret.setP2PSecret(_peerSeed);
    }
    await FlutterP2pCommunicator.startNode(
      peerSeed: _peerSeed,
    );
  }

  _listenToStreams() {
    p2pNodeResponseStream.setUp();
    p2pNodeRequestStream.setUp();
  }

  void stop() {
    _stopP2PNode();
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
