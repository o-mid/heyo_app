import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_p2p_communicator/flutter_p2p_communicator.dart';
import 'package:flutter_p2p_communicator/model/req_res_model.dart';
import 'package:heyo/app/modules/messaging/multiple_connections.dart';
import 'package:heyo/app/modules/p2p_node/p2p_state.dart';
import 'package:heyo/app/modules/shared/utils/extensions/string.extension.dart';
import 'package:heyo/app/modules/web-rtc/signaling.dart';
import 'package:heyo/app/modules/web-rtc/multiple_call_connection_handler.dart';

class P2PNodeRequestStream {
  StreamSubscription<P2PReqResNodeModel?>? _nodeRequestSubscription;
  final P2PState p2pState;
  final CallConnectionsHandler callConnectionsHandler;

  final MultipleConnectionHandler multipleConnectionHandler;
  final JsonDecoder _decoder = const JsonDecoder();

  P2PNodeRequestStream(
      {required this.p2pState,
      required this.callConnectionsHandler,
      required this.multipleConnectionHandler});

  void setUp() {
    // listen to the events from the node side
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
    // 1. prints the event info
    // 2. check if the event is login and if so send a login response
    // 3. check if the event has session and if so convert the incoming request

    debugPrint("_onNewRequestEvent: eventId is: ${event.id}");

    debugPrint("_onNewRequestEvent: eventName is: ${event.name}");
    debugPrint("_onNewRequestEvent: body is: ${event.body}");
    debugPrint("_onNewRequestEvent: error is: ${event.error}");

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
        String request = (event.body!['payload'])['session'];
        // if session is not null then we have a request
        await onRequestReceived(
            request.convertHexToString(), remoteCoreId, remotePeerId);

        //signaling.onMessage(session.convertHexToString(), remoteCoreId, remotePeerId);
      }
    }
  }

  Future<void> onRequestReceived(
      String request, String remoteCoreId, String remotePeerId) async {
    // checks the type of the request and sends it to signalling or messaging accordingly

    Map<String, dynamic> mapData = _decoder.convert(request);
    print("onRequestReceived $mapData : ${mapData['command']} : $remoteCoreId");

    if (mapData['command'] == "call") {
      callConnectionsHandler.onRequestReceived(mapData, remoteCoreId, remotePeerId);
    }
    if (mapData['command'] == "multiple_connection") {
      await multipleConnectionHandler.onRequestReceived(
          mapData, remoteCoreId, remotePeerId);
    } else {}
  }
}
