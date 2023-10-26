import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_p2p_communicator/flutter_p2p_communicator.dart';
import 'package:flutter_p2p_communicator/model/addr_model.dart';
import 'package:flutter_p2p_communicator/model/req_res_model.dart';
import 'package:flutter_p2p_communicator/utils/constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/p2p_node/data/account/account_info.dart';
import 'package:heyo/app/modules/p2p_node/p2p_communicator.dart';
import 'package:heyo/app/modules/p2p_node/p2p_node_request.dart';
import 'package:heyo/app/modules/p2p_node/p2p_node_response.dart';
import 'package:heyo/app/modules/p2p_node/p2p_state.dart';
import 'package:flutter_bip39/bip39.dart';
import 'package:core_web3dart/src/crypto/formatting.dart';
import 'package:core_web3dart/web3dart.dart';
import 'package:heyo/app/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';

class P2PNode {
  final AccountInfo accountInfo;
  final P2PNodeResponseStream p2pNodeResponseStream;
  final P2PNodeRequestStream p2pNodeRequestStream;
  final P2PState p2pState;
  final Web3Client web3client;
  final P2PCommunicator p2pCommunicator;

  P2PNode({
    required this.accountInfo,
    required this.p2pNodeRequestStream,
    required this.p2pNodeResponseStream,
    required this.p2pState,
    required this.web3client,
    required this.p2pCommunicator,
  });

  _setUpP2PNode() async {
    // setup the p2p ResponseStream and RequestStream and listen to them
    _listenToStreams();

    // start the p2p node prosses
    _startP2PNode();
  }

  _startP2PNode() async {
    // start P2P node Prosses

    // 1. check if account is created and if not create it and save it in storage

    // 2. check if peerSeed is created and if not create the generatedMnemonic and hex it and save it in storage

    // 3. find the network id and start the node by using web3client

    // 4. start the node by passing the peerSeed and networkId to the FlutterP2pCommunicator.startNode

    // 5. get the privateKey and send it to the FlutterP2pCommunicator.sendRequest

    // 6. send the P2P_Nodes to the FlutterP2pCommunicator.sendRequest
    // checks if Platform isIOS and if it's the first run of the app clears the Keychain
    if (Platform.isIOS) {
      // remove secure storage data on IOS manually,
      // because it's not cleaned after the app uninstall
      final prefs = await SharedPreferences.getInstance();

      if (prefs.getBool('first_run') ?? true) {
        // sets a key-value pair of first run in IOS NSUserDefaults with shared_preferences
        await prefs.setBool('first_run', false);
        const storage = FlutterSecureStorage();
        await storage.deleteAll();
      }
    }
    if (await accountInfo.getLocalCoreId() == null) {
      await accountInfo.createAccountAndSaveInStorage();
    }

    var peerSeed = await accountInfo.getP2PSecret();

    if (peerSeed == null) {
      final generatedMnemonic =
          await compute(mnemonicToSeed, generateMnemonic());
      peerSeed = bytesToHex(generatedMnemonic.aesKeySeed);
      await accountInfo.setP2PSecret(peerSeed);
    }
    final networkId = await web3client.getNetworkId();

    await FlutterP2pCommunicator.startNode(
      peerSeed: peerSeed,
      networkId: networkId.toString(),
    );

    await p2pCommunicator.addCoreId();

    if (await accountInfo.getSignature() != null) {
      final result = await p2pCommunicator.applyDelegatedAuth();
      if (!result) {
        await Get.offAllNamed(AppPages.INITIAL);
        return;
      }
    }

    await Future.forEach(P2P_Nodes, (P2PAddrModel element) async {
      final info = P2PReqResNodeModel(
          name: P2PReqResNodeNames.connect, body: element.toJson());
      await FlutterP2pCommunicator.sendRequest(info: info);
    });
  }

  _listenToStreams() {
    p2pNodeResponseStream.setUp();
    p2pNodeRequestStream.setUp();
  }

// stop P2P node Prosses by reseting the streams and the state and stoping the node
// by using FlutterP2pCommunicator.stopNode
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
