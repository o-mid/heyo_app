import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_p2p_communicator/flutter_p2p_communicator.dart';
import 'package:flutter_p2p_communicator/model/req_res_model.dart';
import 'package:heyo/app/modules/call_controller/call_state.dart';
import 'package:heyo/app/modules/p2p_node/p2p_state.dart';

class P2PNodeRequestStream {
  StreamSubscription<P2PReqResNodeModel?>? _nodeRequestSubscription;
  final P2PState p2pState;

  P2PNodeRequestStream({required this.p2pState});

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
    debugPrint("_onNewRequestEvent: body is: ${event.body}");

    if (event.name == P2PReqResNodeNames.login &&
        event.error == null &&
        event.body != null) {
      await FlutterP2pCommunicator.sendResponse(
          info: P2PReqResNodeModel(
              name: P2PReqResNodeNames.login, body: {}, id: event.id));

      //
      // MARK: here we are telling the sending party that everything is ok and the req was received
      String remoteCoreId = (event.body!['info'])['remoteCoreID'];
      String remotePeerId = (event.body!['info'])['remotePeerID'];

      String session = (event.body!['payload'])['session'];

      print('csadsadwfa: ${p2pState.callState.value} ');
      if (p2pState.callState.value is NoneState) {
        p2pState.callState.value = CallState.callReceived(
            session, event.id!, remoteCoreId, remotePeerId);
      } else if (p2pState.callState.value is Calling) {
        p2pState.callState.value = CallState.callAccepted(
            session, event.id!, remoteCoreId, remotePeerId);
      }

      // p2pState.callState.value = CALL_STATUS.ACCEPTING_CALL;
      /*  Map<String, String> acceptedCallResponse =
          await webRTCConnection.acceptCall(event.body);
      await FlutterP2pCommunicator.sendResponse(
          info: P2PReqResNodeModel(
              name: P2PReqResNodeNames.login, body: acceptedCallResponse, id: event.id));*/
    }
  }
}
