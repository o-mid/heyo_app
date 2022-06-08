import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_p2p_communicator/flutter_p2p_communicator.dart';
import 'package:flutter_p2p_communicator/model/req_res_model.dart';
import 'package:heyo/app/modules/p2p_node/p2p_state.dart';

class P2PNodeRequestStream {
  StreamSubscription<P2PReqResNodeModel?>? _nodeRequestSubscription;
  final P2PState p2pState;

  P2PNodeRequestStream(
      {required this.p2pState});

  void setUp() {
    _setUpRequestStream();
  }

  void reset() {
    _nodeRequestSubscription?.cancel();
    _nodeRequestSubscription = null;
  }

  _setUpRequestStream() {
    _nodeRequestSubscription ??= FlutterP2pCommunicator.requestStream
        ?.distinct()
        .where((event) => event != null)
        .listen((event) async {
      _onNewRequestEvent(event!);
    });
  }

  _onNewRequestEvent(P2PReqResNodeModel event) async {
    debugPrint("_onNewRequestEvent: eventName is: ${event.name}");

    if (event.name == P2PReqResNodeNames.login &&
        event.error == null &&
        event.body != null) {
      debugPrint("_onNewRequestEvent: New login request received");
      // MARK: here we are telling the sending party that everything is ok and the req was received
      print("adasaca  $event");
     // p2pState.callState.value = CALL_STATUS.ACCEPTING_CALL;
      /*  Map<String, String> acceptedCallResponse =
          await webRTCConnection.acceptCall(event.body);
      await FlutterP2pCommunicator.sendResponse(
          info: P2PReqResNodeModel(
              name: P2PReqResNodeNames.login, body: acceptedCallResponse, id: event.id));*/
    }
  }
}
