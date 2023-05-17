import 'dart:convert';

import 'package:heyo/app/modules/messaging/models.dart';
import 'package:heyo/app/modules/messaging/single_webrtc_connection.dart';

class MultipleConnectionHandler {
  Map<String, RTCSession> connections = {};
  final SingleWebRTCConnection singleWebRTCConnection;

  MultipleConnectionHandler({required this.singleWebRTCConnection});

  Future<RTCSession> getConnection(
      String remoteCoreId, String? remotePeerId) async {
    if (connections[remoteCoreId] == null) {
      return await _createSession(remoteCoreId, null);
    } else {
      (connections[remoteCoreId]!.remotePeer.remotePeerId == null)
          ? connections[remoteCoreId]!.remotePeer.remotePeerId = remotePeerId
          : {};
      return connections[remoteCoreId]!;
    }
  }

  Future<RTCSession> _createSession(
      String remoteCoreId, String? remotePeerId) async {
    RTCSession rtcSession =
        await singleWebRTCConnection.createSession(remoteCoreId, remotePeerId);
    connections[remoteCoreId] = rtcSession;
    return connections[remoteCoreId]!;
  }

  Future<bool> initiateSession(RTCSession rtcSession) async {
    return await singleWebRTCConnection.startSession(rtcSession);
  }

  onRequestReceived(
      Map<String, dynamic> mapData, String remoteCoreId, String remotePeerId) async {
    var data = mapData[DATA];
    print("onMessage, type: ${mapData['type']}");

    switch (mapData['type']) {
      case offer:
        {
          RTCSession rtcSession =
              await getConnection(remoteCoreId, remotePeerId);
          var description = data[DATA_DESCRIPTION];
          singleWebRTCConnection.onOfferReceived(rtcSession, description);
        }
        break;
      case answer:
        {
          RTCSession rtcSession =
              await getConnection(remotePeerId, remotePeerId);
          var description = data[DATA_DESCRIPTION];
          singleWebRTCConnection.onAnswerReceived(rtcSession, description);
        }
        break;
      case candidate:
        {
          RTCSession rtcSession= await getConnection(remoteCoreId, remotePeerId);
          var candidateMap = data[candidate];

          singleWebRTCConnection.onCandidateReceived(rtcSession,candidateMap);
        }
        break;
    }
  }
}
