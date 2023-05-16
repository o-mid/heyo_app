import 'dart:convert';

import 'package:heyo/app/modules/messaging/models.dart';
import 'package:heyo/app/modules/messaging/single_webrtc_connection.dart';

class MultipleConnectionHandler {
  Map<String, RTCSession> connections = {};
  final SingleWebRTCConnection singleWebRTCConnection;
  final JsonEncoder _encoder = const JsonEncoder();
  final JsonDecoder _decoder = const JsonDecoder();

  MultipleConnectionHandler({required this.singleWebRTCConnection});

  Future<RTCSession> getConnection(
      String remoteCoreId, String? remotePeerId) async {
    if (connections[remoteCoreId] == null) {
      return await _createSession(remoteCoreId, null);
    } else {
      return connections[remoteCoreId]!;
    }
  }

  Future<RTCSession> _createSession(String remoteCoreId, String? remotePeerId) async {
    RTCSession rtcSession =
        await singleWebRTCConnection.createSession(remoteCoreId, remotePeerId);
    connections[remoteCoreId] = rtcSession;
    return connections[remoteCoreId]!;
  }

  initiateSession(RTCSession rtcSession) {
    singleWebRTCConnection.startSession(rtcSession);
  }

  onRequestReceived(
      String message, String remoteCoreId, String remotePeerId) async {
    Map<String, dynamic> mapData = _decoder.convert(message);
    var data = mapData[DATA];
    print("onMessage, type: ${mapData['type']}");

    switch (mapData['type']) {
      case connectionRequestEvent:
        {
          RTCSession rtcSession = await getConnection(remoteCoreId, remotePeerId);
          //  bool result = await singleWebRTCConnection.startSession(rtcSession);
        }
        break;
      case ANSWER_EVENT_TYPE:
        {}
        break;
      case CANDIDATE_EVENT_TYPE:
        {
          //  await _onCandidateReceived(data, remoteCoreId, remotePeerId);
        }
        break;
    }
  }
}
