import 'dart:convert';

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:heyo/app/modules/messaging/models.dart';
import 'package:heyo/app/modules/messaging/web_rtc_connection_manager.dart';
import 'package:heyo/app/modules/p2p_node/p2p_communicator.dart';

const MEDIA_TYPE = 'data';

const COMMAND = 'multiple_connection';
const DATA = 'data';

const candidate = 'candidate';
const offer = 'offer';
const answer = 'answer';
const initiate = 'initiate';
const DATA_DESCRIPTION = 'description';
const CONNECTION_ID = 'connection_id';

class SingleWebRTCConnection {
  final P2PCommunicator p2pCommunicator;
  final WebRTCConnectionManager webRTCConnectionManager;
  final JsonEncoder _encoder = const JsonEncoder();
  final JsonDecoder _decoder = const JsonDecoder();
  Function(ConnectionId, String)? onConnectionFailed;

  SingleWebRTCConnection(
      {required this.p2pCommunicator, required this.webRTCConnectionManager});

  Future<RTCSession> _createRTCSession(ConnectionId connectionId,
      String remoteCoreId, String? remotePeer) async {
    RTCPeerConnection peerConnection =
        await webRTCConnectionManager.createRTCPeerConnection();
    RTCSession rtcSession = RTCSession(
        connectionId: connectionId,
        remotePeer:
            RemotePeer(remoteCoreId: remoteCoreId, remotePeerId: remotePeer),
        onConnectionFailed: (id, remote) {
          onConnectionFailed?.call(id, remote);
        });
    rtcSession.pc = peerConnection;
    rtcSession.remotePeer.remotePeerId = remotePeer;
    webRTCConnectionManager.setListeners(rtcSession.pc!,
        onIceCandidate: (candidate) => _sendCandidate(candidate, rtcSession));
    return rtcSession;
  }

  Future<RTCSession> createSession(ConnectionId connectionId,
      String remoteCoreId, String? remotePeer) async {
    return await _createRTCSession(connectionId, remoteCoreId, remotePeer);
  }

  Future<bool> startSession(RTCSession rtcSession) async {
    print("onMessage startty");
    RTCSessionDescription rtcSessionDescription =
        await webRTCConnectionManager.setupUpOffer(rtcSession.pc!, MEDIA_TYPE);
    print("onMessage send");

    return await _send(
        offer,
        {
          DATA_DESCRIPTION: {
            'sdp': rtcSessionDescription.sdp,
            'type': rtcSessionDescription.type
          },
          'media': MEDIA_TYPE,
        },
        rtcSession.remotePeer.remoteCoreId,
        rtcSession.remotePeer.remotePeerId,
        rtcSession.connectionId);
  }

  Future<bool> initiateSession(String remoteCoreId) async {
    return await _send(initiate, {}, remoteCoreId, null, null);
  }

  void onOfferReceived(RTCSession rtcSession, description) async {
    await rtcSession.pc!.setRemoteDescription(
        RTCSessionDescription(description['sdp'], description['type']));
    RTCSessionDescription sessionDescription =
        await webRTCConnectionManager.setupAnswer(rtcSession.pc!, MEDIA_TYPE);
    print("onMessage onOfferReceived Send");

    var completed = await _send(
        answer,
        {
          'description': {
            'sdp': sessionDescription.sdp,
            'type': sessionDescription.type
          },
        },
        rtcSession.remotePeer.remoteCoreId,
        rtcSession.remotePeer.remotePeerId,
        rtcSession.connectionId);
    print("onMessage onOfferReceived Send result: $completed");
  }

  void onAnswerReceived(RTCSession rtcSession, description) async {
    print("onMessage onAnswerReceived");

    await rtcSession.pc!.setRemoteDescription(
      RTCSessionDescription(
        description['sdp'],
        description['type'],
      ),
    );
  }

  _sendCandidate(RTCIceCandidate iceCandidate, RTCSession rtcSession) {
    _send(
        candidate,
        {
          candidate: {
            'sdpMLineIndex': iceCandidate.sdpMLineIndex,
            'sdpMid': iceCandidate.sdpMid,
            'candidate': iceCandidate.candidate,
          },
        },
        rtcSession.remotePeer.remoteCoreId,
        rtcSession.remotePeer.remotePeerId,
        rtcSession.connectionId);
  }

  Future<bool> _send(
      eventType, data, remoteCoreId, remotePeerId, connectionId) async {
    print(
        "onMessage send $remotePeerId : $remoteCoreId : $connectionId : $eventType : $data ");
    var request = {};
    request["type"] = eventType;
    request["data"] = data;
    request["command"] = COMMAND;
    request[CONNECTION_ID] = connectionId;
    print("P2PCommunicator: sendingSDP $remoteCoreId : $eventType");
    bool requestSucceeded = await p2pCommunicator.sendSDP(
        _encoder.convert(request), remoteCoreId, remotePeerId);
    print(
        "P2PCommunicator: sendingSDP $remoteCoreId : $eventType : $requestSucceeded");

    return requestSucceeded;
  }

  void onCandidateReceived(RTCSession rtcSession, candidateMap) async {
    RTCIceCandidate candidate = RTCIceCandidate(
      candidateMap['candidate'],
      candidateMap['sdpMid'],
      candidateMap['sdpMLineIndex'],
    );
    if (rtcSession.isConnectionStable()) {
      await rtcSession.pc!.addCandidate(candidate);
    } else {
      rtcSession.remoteCandidates.add(candidate);
    }
  }
}
