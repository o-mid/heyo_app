import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_p2p_communicator/flutter_p2p_communicator.dart';
import 'package:flutter_p2p_communicator/model/addr_model.dart';
import 'package:flutter_p2p_communicator/model/delegate_auth_model.dart';
import 'package:flutter_p2p_communicator/model/req_res_model.dart';
import 'package:flutter_p2p_communicator/utils/constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/p2p_node/models.dart';
import 'package:heyo/app/modules/shared/providers/account/creation/account_creation.dart';
import 'package:heyo/app/modules/shared/providers/account/creation/libp2p_account_creation.dart';

import 'package:heyo/app/modules/p2p_node/p2p_node_request.dart';
import 'package:heyo/app/modules/p2p_node/p2p_node_response.dart';
import 'package:heyo/app/modules/p2p_node/p2p_state.dart';
import 'package:flutter_bip39/bip39.dart';
import 'package:core_web3dart/src/crypto/formatting.dart';
import 'package:core_web3dart/web3dart.dart';
import 'package:heyo/app/modules/shared/providers/crypto/storage/libp2p_storage_provider.dart';
import 'package:heyo/app/modules/shared/utils/extensions/string.extension.dart';
import 'package:heyo/app/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';

class P2PNode {
  final LibP2PStorageProvider libP2PStorageProvider;
  final AccountCreation accountCreation;
  final P2PNodeResponseStream p2pNodeResponseStream;
  final P2PNodeRequestStream p2pNodeRequestStream;
  final P2PState p2pState;
  final Web3Client web3client;

  P2PNode({
    required this.libP2PStorageProvider,
    required this.accountCreation,
    required this.p2pNodeRequestStream,
    required this.p2pNodeResponseStream,
    required this.p2pState,
    required this.web3client,
  });

  void _setUpP2PNode(void Function(P2PReqResNodeModel model) onNewRequestReceived) {
    // setup the p2p ResponseStream and RequestStream and listen to them
    _listenToStreams(onNewRequestReceived);

    // start the p2p node prosses
    _startP2PNode();
  }

  Future<void> initNode() async {
    // start P2P node Prosses

    // 1. check if account is created and if not create it and save it in storage

    // 2. check if peerSeed is created and if not create the generatedMnemonic and hex it and save it in storage

    // 3. find the network id and start the node by using web3client

    // 4. start the node by passing the peerSeed and networkId to the FlutterP2pCommunicator.startNode

    // 5. get the privateKey and send it to the FlutterP2pCommunicator.sendRequest

    // 6. send the P2P_Nodes to the FlutterP2pCommunicator.sendRequest

    if (await libP2PStorageProvider.getLocalCoreId() == null) {
      final result = await accountCreation.createAccount();
      await accountCreation.saveAccount(result);
    }

    var peerSeed = await libP2PStorageProvider.getP2PSecret();

    if (peerSeed == null) {
      final generatedMnemonic =
          await compute(mnemonicToSeed, generateMnemonic());
      peerSeed = bytesToHex(generatedMnemonic.aesKeySeed);
      await libP2PStorageProvider.setP2PSecret(peerSeed);
    }
  }

  void _startP2PNode() async {
    final peerSeed = await libP2PStorageProvider.getP2PSecret();

    final networkId = await web3client.getNetworkId();

    await FlutterP2pCommunicator.startNode(
      peerSeed: peerSeed!,
      enableStaticRelays: true,
      networkId: networkId.toString(),
    );

    final coreIdSetResult = await _addCoreId();

    /// if we cannot set core id means go_com is not functional
    /// no need to continue
    if (!coreIdSetResult) return;

    if (await libP2PStorageProvider.getSignature() != null) {
      await applyDelegatedAuth();
    }

    _applyConnectRequest();
  }

  Future<void> _applyConnectRequest() async {
    await Future.forEach(libP2PNodes, (P2PAddrModel element) async {
      unawaited(_sendConnectRequest(element));
    });
  }

  Future<void> _sendConnectRequest(P2PAddrModel element) async {
    final info = P2PReqResNodeModel(
      name: P2PReqResNodeNames.connect,
      body: element.toJson(),
    );

    final result = await p2pState
        .trackRequest(await FlutterP2pCommunicator.sendRequest(info: info));
    if (result != true) {
      Future.delayed(const Duration(seconds: 4), () async {
        unawaited(_sendConnectRequest(element));
      });
    }
  }

  void _listenToStreams(
      void Function(P2PReqResNodeModel model) onNewRequestReceived,) {
    p2pNodeResponseStream.setUp();
    p2pNodeRequestStream.setUp(onNewRequestReceived);
  }

// stop P2P node Prosses by reseting the streams and the state and stoping the node
// by using FlutterP2pCommunicator.stopNode
  Future<void> stop() async {
    await _stopP2PNode();
    p2pState.reset();
    p2pNodeRequestStream.reset();
    p2pNodeResponseStream.reset();
    //TODO reset values
  }

  Future<void> _stopP2PNode() async {
    await FlutterP2pCommunicator.stopNode();
  }

  Future<bool> _addCoreId() async {
    final privateKey = await libP2PStorageProvider.getPrivateKey();
    final privToAdd = P2PReqResNodeModel(
        name: P2PReqResNodeNames.addCoreID, body: {"privKey": privateKey});

    final id = await FlutterP2pCommunicator.sendRequest(info: privToAdd);

    return p2pState.trackRequest(id);
  }

  Future<bool> applyDelegatedAuth() async {
    final localCoreId = await libP2PStorageProvider.getLocalCoreId();
    final delegatedSignature = await libP2PStorageProvider.getSignature();

    final delegatedAuth = DelegateAuthModel(
      localCoreId: localCoreId!,
      delegateName: DelegateName.heyo,
      delegatedSignature: delegatedSignature!,
    );
    final id = await FlutterP2pCommunicator.sendRequest(
      info: P2PReqResNodeModel(
        name: P2PReqResNodeNames.addDelegatedCoreID,
        body: delegatedAuth.toJson(),
      ),
    );
    return p2pState.trackRequest(id);
  }

  Future<void> restart(
      void Function(P2PReqResNodeModel model) onNewRequestReceived) async {
    _setUpP2PNode(onNewRequestReceived);
  }
}
