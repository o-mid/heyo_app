import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_p2p_communicator/flutter_p2p_communicator.dart';
import 'package:flutter_p2p_communicator/model/req_res_model.dart';
import 'package:heyo/app/modules/call_controller/call_state.dart';
import 'package:heyo/app/modules/p2p_node/p2p_state.dart';
import 'package:heyo/app/modules/shared/utils/extensions/string.extension.dart';

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
    debugPrint("_onNewRequestEvent: eventId is: ${event.id}");

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

      if ((event.body!['payload'])['session'] != null) {
        String session = (event.body!['payload'])['session'];
        Map<String, dynamic> data =
            await jsonDecode(session.convertHexToString());
        String? sdp = data['sdp'];
        String? candidate = data['candidate'];
       String callId=data['call_id'];

        print("sdp: $sdp : candidate: $candidate");

        if (sdp != null) {
          if (p2pState.callState.value is NoneState) {
            print("Call: in noneState: ${(!p2pState.recordedCallIds.value.contains(callId))}");

            if (!p2pState.recordedCallIds.value.contains(callId)) {
              print("Call: Call Received");
              p2pState.recordedCallIds.value.add(callId);
              p2pState.currentCallId.value=callId;

              p2pState.callState.value = CallState.callReceived(
                  sdp, remoteCoreId, remotePeerId);
            }
          } else if (p2pState.callState.value is Calling) {
            print("Call: in inCall: ${(p2pState.recordedCallIds.value.contains(callId))}");

            if (p2pState.recordedCallIds.value.contains(callId)){
              p2pState.currentCallId.value=callId;
              p2pState.callState.value = CallState.callAccepted(
                  sdp, remoteCoreId, remotePeerId);
            }
          }
        } else if (candidate != null) {
          print("Call: Call exchanging candidate");
          p2pState.candidate.value = candidate;
        } else {
          if( !p2pState.endedCallIds.value.contains(callId)) {
            print("Call: Call Ended");
            p2pState.endedCallIds.value.add(callId);
            p2pState.callState.value = CallState.ended();
          }
        }
      }
    }
  }
}
