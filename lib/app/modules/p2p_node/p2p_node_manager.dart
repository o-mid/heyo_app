import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:heyo/app/modules/p2p_node/p2p_node.dart';
import 'package:heyo/app/modules/p2p_node/p2p_state.dart';

class P2PNodeController {
  ConnectivityResult? _latestConnectivityStatus;
  final P2PNode p2pNode;
  final P2PState p2pState;
  P2PNodeController({required this.p2pNode,required this.p2pState}){
    _init();
  }

  void _init(){
    Connectivity().onConnectivityChanged.listen((connectivityResult) async {
      debugPrint("onConnectivityChanged: $connectivityResult");
      if (connectivityResult == ConnectivityResult.none) {
        p2pState.reset();
        print("Device not connected to any network");
      } else {
        if (_latestConnectivityStatus != null) {
          _stopP2PNode();
        }
        _setUpP2PNode();
        print('New networkStatus: $connectivityResult');
        _latestConnectivityStatus = connectivityResult;
      }
    });
  }

  void _stopP2PNode() {
    print("p2p stopNode");
    p2pNode.stop();
  }

  void _setUpP2PNode() {
    print("p2p startNode");
    p2pNode.restart();
  }

}
