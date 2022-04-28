import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:heyo/app/modules/p2p_node/p2p_node.dart';

class P2PNodeManager extends GetxController {
  ConnectivityResult? _latestConnectivityStatus;
  final P2PNode p2pNode;
  P2PNodeManager({required this.p2pNode});


  @override
  void onReady() async {
    Connectivity().onConnectivityChanged.listen((connectivityResult) async {
      if (connectivityResult == ConnectivityResult.none) {
        debugPrint("Device not connected to any network");
      } else {
        if (_latestConnectivityStatus != null) {
          _stopP2PNode();
        }
        _setUpP2PNode();
        debugPrint("New networkStatus: ${connectivityResult}");
        _latestConnectivityStatus = connectivityResult;
      }
    });
    super.onReady();
  }

  _stopP2PNode(){
    p2pNode.stop();
  }
  _setUpP2PNode(){
    p2pNode.restart();
  }

}
