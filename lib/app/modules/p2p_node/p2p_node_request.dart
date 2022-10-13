import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_p2p_communicator/flutter_p2p_communicator.dart';
import 'package:flutter_p2p_communicator/model/req_res_model.dart';
import 'package:heyo/app/modules/p2p_node/p2p_state.dart';
import 'package:heyo/app/modules/shared/utils/extensions/string.extension.dart';
import 'package:heyo/app/modules/web-rtc/signaling.dart';

import '../messaging/messaging.dart';

class P2PNodeRequestStream {
  StreamSubscription<P2PReqResNodeModel?>? _nodeRequestSubscription;
  final P2PState p2pState;
  final Signaling signaling;
  final Messaging messaging;
  final JsonDecoder _decoder = const JsonDecoder();

  P2PNodeRequestStream({required this.p2pState, required this.signaling, required this.messaging});

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
    debugPrint("_onNewRequestEvent: error is: ${event.error}");

    if (event.name == P2PReqResNodeNames.login && event.error == null && event.body != null) {
      await FlutterP2pCommunicator.sendResponse(
          info: P2PReqResNodeModel(name: P2PReqResNodeNames.login, body: {}, id: event.id));

      //
      // MARK: here we are telling the sending party that everything is ok and the req was received
      String remoteCoreId = (event.body!['info'])['remoteCoreID'];
      String remotePeerId = (event.body!['info'])['remotePeerID'];

      if ((event.body!['payload'])['session'] != null) {
        String request = (event.body!['payload'])['session'];

        onRequestReceived(request.convertHexToString(), remoteCoreId, remotePeerId);

        //signaling.onMessage(session.convertHexToString(), remoteCoreId, remotePeerId);

      }
    }
  }

  void onRequestReceived(String request, String remoteCoreId, String remotePeerId) {
    Map<String, dynamic> mapData = _decoder.convert(request);

    if (mapData['command'] == "call") {
      signaling.onMessage(mapData, remoteCoreId, remotePeerId);
    } else {
      messaging.onMessage(mapData, remoteCoreId, remotePeerId);
    }
  }
}
