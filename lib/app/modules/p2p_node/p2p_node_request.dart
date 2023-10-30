import 'dart:async';
import 'package:flutter_p2p_communicator/flutter_p2p_communicator.dart';
import 'package:flutter_p2p_communicator/model/req_res_model.dart';
import 'package:heyo/app/modules/p2p_node/p2p_state.dart';

class P2PNodeRequestStream {
  StreamSubscription<P2PReqResNodeModel?>? _nodeRequestSubscription;
  final P2PState p2pState;

  P2PNodeRequestStream({
    required this.p2pState,
  });

  void setUp(void Function(P2PReqResNodeModel model) onNewRequestReceived) {
    // listen to the events from the node side
    _setUpRequestStream(onNewRequestReceived);
  }

  void reset() {
    _nodeRequestSubscription?.cancel();
    _nodeRequestSubscription = null;
  }

  void _setUpRequestStream(
      void Function(P2PReqResNodeModel model) onNewRequestReceived) {
    _nodeRequestSubscription ??= FlutterP2pCommunicator.requestStream
        ?.distinct()
        .where((event) => event != null)
        .listen((event) async {
      onNewRequestReceived(event!);
    });
  }
}
