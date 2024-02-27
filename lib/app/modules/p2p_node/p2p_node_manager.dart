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
    void Function(P2PReqResNodeModel model) onNewRequestReceived,
  ) async {
    this.onNewRequestReceived = onNewRequestReceived;
    _setUpP2PNode();
 /*   final connectionStatus = await Connectivity().checkConnectivity();
    startNode(connectionStatus);*/
    // this only calls startNode when status gets changed.
   /* Connectivity().onConnectivityChanged.listen((connectivityResult) async {
      debugPrint('onConnectivityChanged: $connectivityResult');
      startNode(connectionStatus);
    });*/
  }

  void startNode(ConnectivityResult connectionStatus) async{
    if (connectionStatus == ConnectivityResult.none) {
      p2pState.reset();
      await _stopP2PNode();
      debugPrint('Device not connected to any network');
    } else {
      if (_latestConnectivityStatus != null) {
        await _stopP2PNode();
      }
      _setUpP2PNode();
      debugPrint('New networkStatus: $connectionStatus');
      _latestConnectivityStatus = connectionStatus;
    }
  }

  Future<void> _stopP2PNode() async {
    debugPrint('p2p stopNode');
    await p2pNode.stop();
  }

  void _setUpP2PNode() {
    debugPrint('p2p startNode');
    p2pNode.restart(onNewRequestReceived!);
  }
}
