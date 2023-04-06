import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_p2p_communicator/flutter_p2p_communicator.dart';
import 'package:flutter_p2p_communicator/model/addr_model.dart';
import 'package:flutter_p2p_communicator/model/req_res_model.dart';
import 'package:flutter_p2p_communicator/utils/constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:heyo/app/modules/p2p_node/data/account/account_info.dart';
import 'package:heyo/app/modules/p2p_node/p2p_node_request.dart';
import 'package:heyo/app/modules/p2p_node/p2p_node_response.dart';
import 'package:heyo/app/modules/p2p_node/p2p_state.dart';
import 'package:flutter_bip39/bip39.dart';
import 'package:core_web3dart/src/crypto/formatting.dart';
import 'package:core_web3dart/web3dart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class P2PNode {
  final AccountInfo accountInfo;
  final P2PNodeResponseStream p2pNodeResponseStream;
  final P2PNodeRequestStream p2pNodeRequestStream;
  final P2PState p2pState;
  final Web3Client web3client;

  P2PNode({
    required this.accountInfo,
    required this.p2pNodeRequestStream,
    required this.p2pNodeResponseStream,
    required this.p2pState,
    required this.web3client,
  });

  _setUpP2PNode() async {
    _listenToStreams();
    _startP2PNode();
  }

  _startP2PNode() async {
    // checks if Platform isIOS and if it's the first run of the app clears the Keychain
    if (Platform.isIOS) {
      // remove secure storage data on IOS manually,
      // because it's not cleaned after the app uninstall
      final prefs = await SharedPreferences.getInstance();

      if (prefs.getBool('first_run') ?? true) {
        // sets a key-value pair of first run in IOS NSUserDefaults with shared_preferences
        prefs.setBool('first_run', false);
        FlutterSecureStorage storage = const FlutterSecureStorage();
        await storage.deleteAll();
      }
    }
    if (await accountInfo.getCoreId() == null) {
      await accountInfo.createAccountAndSaveInStorage();
    }

    String? peerSeed = await accountInfo.getP2PSecret();

    if (peerSeed == null) {
      final generatedMnemonic = await compute(mnemonicToSeed, generateMnemonic());
      peerSeed = bytesToHex(generatedMnemonic.aesKeySeed);
      await accountInfo.setP2PSecret(peerSeed);
    }
    int networkId = await web3client.getNetworkId();
    await FlutterP2pCommunicator.startNode(peerSeed: peerSeed, networkId: networkId.toString());

    final privateKey = await accountInfo.getPrivateKey();
    final privToAdd =
        P2PReqResNodeModel(name: P2PReqResNodeNames.addCoreID, body: {"privKey": privateKey});

    await FlutterP2pCommunicator.sendRequest(info: privToAdd);

    await Future.forEach(P2P_Nodes, (P2PAddrModel element) async {
      final info = P2PReqResNodeModel(name: P2PReqResNodeNames.connect, body: element.toJson());
      await FlutterP2pCommunicator.sendRequest(info: info);
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
