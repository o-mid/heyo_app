import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_p2p_communicator/flutter_p2p_communicator.dart';
import 'package:flutter_p2p_communicator/model/req_res_model.dart';
import 'package:heyo/app/modules/connection/domain/connection_contractor.dart';
import 'package:heyo/app/modules/messages/connection/models/models.dart';
import 'package:heyo/app/modules/p2p_node/p2p_communicator.dart';
import 'package:heyo/app/modules/p2p_node/p2p_node_manager.dart';
import 'package:heyo/app/modules/shared/utils/extensions/string.extension.dart';
import 'package:heyo/app/modules/connection/domain/connection_models.dart';

class LibP2PConnectionContractor extends ConnectionContractor {
  LibP2PConnectionContractor({
    required this.p2pNodeController,
    required this.p2pCommunicator,
  }) {
    init();
  }

  final JsonDecoder _decoder = const JsonDecoder();

  final P2PNodeController p2pNodeController;
  final P2PCommunicator p2pCommunicator;

  final StreamController<LibP2PRequestReceived> _streamController =
      StreamController<LibP2PRequestReceived>.broadcast();

  @override
  Future<bool> sendMessage(String data, remoteId) {
    final remotePeer = remoteId as RemotePeer;
    return p2pCommunicator.sendSDP(data, remotePeer.remoteCoreId, remotePeer.remoteCoreId);
  }

  //unCompleted

  @override
  void init() {
    p2pNodeController.init(_onNewRequestEvent);
  }

  Future<void> _onNewRequestEvent(P2PReqResNodeModel event) async {
    // 1. prints the event info
    // 2. check if the event is login and if so send a login response
    // 3. check if the event has session and if so convert the incoming request

    debugPrint("_onNewRequestEvent: eventId is: ${event.id}");

    debugPrint("_onNewRequestEvent: eventName is: ${event.name}");
    debugPrint("_onNewRequestEvent: body is: ${event.body}");
    debugPrint("_onNewRequestEvent: error is: ${event.error}");

    if (event.name == P2PReqResNodeNames.signaling && event.error == null && event.body != null) {
      await FlutterP2pCommunicator.sendResponse(
        info: P2PReqResNodeModel(
          name: P2PReqResNodeNames.signaling,
          body: {},
          id: event.id,
        ),
      );

      //
      // MARK: here we are telling the sending party that everything is ok and the req was received
      final remoteCoreId =
          (event.body!['info'] as Map<String, dynamic>)['remoteDelegatedCoreID'] as String;

      final remotePeerId = (event.body!['info'] as Map<String, dynamic>)['remotePeerID'] as String;

      if ((event.body!['payload'] as Map<String, dynamic>)['data'] != null) {
        final request = (event.body!['payload'] as Map<String, dynamic>)['data'] as String;
        // if session is not null then we have a request
        await onRequestReceived(
          request.convertHexToString(),
          remoteCoreId,
          remotePeerId,
        );
      }
    }
  }

  Future<void> onRequestReceived(
    String request,
    String remoteCoreId,
    String remotePeerId,
  ) async {
    // checks the type of the request and sends it to signalling or messaging accordingly
    var mapData = _decoder.convert(request) as Map<String, dynamic>;
    print("onRequestReceived $mapData : ${mapData['command']} : $remoteCoreId");

    if (mapData['command'] == "call") {
      _streamController.add(
        CallConnectionDataReceived(
          remoteCoreId: remoteCoreId,
          remotePeerId: remotePeerId,
          mapData: mapData,
        ),
      );
    }
    if (mapData['command'] == "multiple_connection") {
      _streamController.add(
        ChatMultipleConnectionDataReceived(
          remoteCoreId: remoteCoreId,
          remotePeerId: remotePeerId,
          mapData: mapData,
        ),
      );
    } else {}
  }

  @override
  Stream<LibP2PRequestReceived> getMessageStream() {
    return _streamController.stream.asBroadcastStream();
  }
}
