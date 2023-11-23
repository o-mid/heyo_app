import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_p2p_communicator/model/req_res_model.dart';
import 'package:heyo/app/modules/p2p_node/p2p_node.dart';
import 'package:heyo/app/modules/p2p_node/p2p_state.dart';

class P2PNodeController {
  P2PNodeController({required this.p2pNode, required this.p2pState});

  ConnectivityResult? _latestConnectivityStatus;
  final P2PNode p2pNode;
  final P2PState p2pState;
  void Function(P2PReqResNodeModel model)? onNewRequestReceived;

  Future<void> init() async {
    return p2pNode.initNode();
  }

  Future<void> start(
      void Function(P2PReqResNodeModel model) onNewRequestReceived) async {
    this.onNewRequestReceived = onNewRequestReceived;
    final connectionStatus = await Connectivity().checkConnectivity();
    startNode(connectionStatus);
    // this only calls startNode when status gets changed.
    Connectivity().onConnectivityChanged.listen((connectivityResult) async {
      debugPrint('onConnectivityChanged: $connectivityResult');
      startNode(connectionStatus);
    });
  }

  void startNode(ConnectivityResult connectionStatus) {
    if (connectionStatus == ConnectivityResult.none) {
      p2pState.reset();
      debugPrint('Device not connected to any network');
    } else {
      if (_latestConnectivityStatus != null) {
        _stopP2PNode();
      }
      _setUpP2PNode();
      debugPrint('New networkStatus: $connectionStatus');
      _latestConnectivityStatus = connectionStatus;
    }
  }

  void _stopP2PNode() {
    debugPrint('p2p stopNode');
    p2pNode.stop();
  }

  void _setUpP2PNode() {
    debugPrint('p2p startNode');
    p2pNode.restart(onNewRequestReceived!);
  }

  Future<void> stop() async {
    return p2pNode.stop();
  }

  Future<void> restart() async {
    return p2pNode.restart(onNewRequestReceived!);
  }

  Future<bool> applyDelegatedAuth() {
    return p2pNode.applyDelegatedAuth();
  }
}
