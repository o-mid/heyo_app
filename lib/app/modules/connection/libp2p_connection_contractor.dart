import 'dart:async';

import 'package:heyo/app/modules/connection/connection_contractor.dart';
import 'package:heyo/app/modules/p2p_node/p2p_communicator.dart';
import 'package:heyo/app/modules/p2p_node/p2p_node_manager.dart';

class LibP2PConnectionContractor extends ConnectionContractor {
  LibP2PConnectionContractor(
      { required this.p2pNodeController, required this.p2pCommunicator,});

  final P2PNodeController p2pNodeController;
  final P2PCommunicator p2pCommunicator;

  final StreamController<String> _streamController = StreamController();

  @override
  Future<void> sendMessage(String data, remoteId) {
    final remoteCoreId = remoteId as String;
    return p2pCommunicator.sendSDP(data, remoteCoreId, null);
  }

  @override
  Stream<String> getMessageStream() {
    return _streamController.stream.asBroadcastStream();
  }

  @override
  void init(data) {
    p2pNodeController.init();
  }
}
