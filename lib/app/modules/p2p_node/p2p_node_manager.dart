import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:heyo/app/modules/p2p_node/p2p_node.dart';
import 'package:heyo/app/modules/p2p_node/p2p_state.dart';


class P2PNodeController {
  P2PNodeController({required this.p2pNode, required this.p2pState}) {
    init();
  }

  ConnectivityResult? _latestConnectivityStatus;
  final P2PNode p2pNode;
  final P2PState p2pState;

  void init() {
    Connectivity().onConnectivityChanged.listen((connectivityResult) async {
      debugPrint('onConnectivityChanged: $connectivityResult');
      if (connectivityResult == ConnectivityResult.none) {
        p2pState.reset();
        debugPrint('Device not connected to any network');
      } else {
        if (_latestConnectivityStatus != null) {
          _stopP2PNode();
        }
        _setUpP2PNode();
        debugPrint('New networkStatus: $connectivityResult');
        _latestConnectivityStatus = connectivityResult;
      }
    });
  }

  void _stopP2PNode() {
    debugPrint('p2p stopNode');
    p2pNode.stop();
  }

  void _setUpP2PNode() {
    debugPrint('p2p startNode');
    p2pNode.restart();
  }

  Future<bool> applyDelegatedAuth() {
    return p2pNode.applyDelegatedAuth();
  }

}
