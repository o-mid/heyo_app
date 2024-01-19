import 'dart:convert';

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:heyo/app/modules/connection/domain/connection_contractor.dart';
import 'package:heyo/app/modules/connection/data/libp2p_connection_contractor.dart';
import 'package:heyo/app/modules/connection/domain/connection_models.dart';
import 'package:heyo/app/modules/messages/connection/models/models.dart';
import 'package:heyo/app/modules/messages/connection/web_rtc_connection_manager.dart';

const MEDIA_TYPE = 'data';

const COMMAND = 'multiple_connection';
const DATA = 'data';

const candidate = 'candidate';
const offer = 'offer';
const answer = 'answer';
//const initiate = 'initiate';
const DATA_DESCRIPTION = 'description';
const CONNECTION_ID = 'connection_id';

class SingleWebRTCConnection {
  final ConnectionContractor connectionContractor;
  final WebRTCConnectionManager webRTCConnectionManager;
  final JsonEncoder _encoder = const JsonEncoder();
  final JsonDecoder _decoder = const JsonDecoder();
  Function(ConnectionId, String)? onConnectionFailed;

  SingleWebRTCConnection(
      {required this.connectionContractor, required this.webRTCConnectionManager});

  Future<RTCSession> _createRTCSession(
    ConnectionId connectionId,
    String remoteCoreId,
    String? remotePeer,
  ) async {
    RTCPeerConnection peerConnection = await webRTCConnectionManager.createRTCPeerConnection();
    final rtcSession = RTCSession(
        connectionId: connectionId,
        remotePeer: RemotePeer(remoteCoreId: remoteCoreId, remotePeerId: remotePeer),
        onConnectionFailed: (id, remote) {
          onConnectionFailed?.call(id, remote);
        });
    rtcSession.pc = peerConnection;
    rtcSession.remotePeer.remotePeerId = remotePeer;
    webRTCConnectionManager.setListeners(rtcSession.pc!,
        onIceCandidate: (candidate) => _sendCandidate(candidate, rtcSession));
    return rtcSession;
  }

  Future<RTCSession> createSession(
    ConnectionId connectionId,
    String remoteCoreId,
    String? remotePeer,
  ) async {
    return await _createRTCSession(
      connectionId,
      remoteCoreId,
      remotePeer,
    );
  }

  Future<bool> startSession(RTCSession rtcSession) async {
    print("startSession");
    await rtcSession.createDataChannel();
    RTCSessionDescription rtcSessionDescription =
        await webRTCConnectionManager.setupUpOffer(rtcSession.pc!, MEDIA_TYPE);
    print("onMessage send");

    return await _send(
      offer,
      {
        DATA_DESCRIPTION: {'sdp': rtcSessionDescription.sdp, 'type': rtcSessionDescription.type},
        'media': MEDIA_TYPE,
      },
      rtcSession.remotePeer.remoteCoreId,
      rtcSession.remotePeer.remotePeerId,
      rtcSession.connectionId,
    );
  }

  /*Future<bool> initiateSession(RTCSession rtcSession) async {
    return await _send(initiate, {}, rtcSession.remotePeer.remoteCoreId,
        rtcSession.remotePeer.remotePeerId, rtcSession.connectionId);
  }*/

  Future<void> onOfferReceived(RTCSession rtcSession, Map<String, dynamic> description) async {
    await rtcSession.pc!.setRemoteDescription(
        RTCSessionDescription(description['sdp'] as String?, description['type'] as String?));
    RTCSessionDescription sessionDescription =
        await webRTCConnectionManager.setupAnswer(rtcSession.pc!, MEDIA_TYPE);
    print("onMessage onOfferReceived Send");

    _send(
      answer,
      {
        'description': {'sdp': sessionDescription.sdp, 'type': sessionDescription.type},
      },
      rtcSession.remotePeer.remoteCoreId,
      rtcSession.remotePeer.remotePeerId,
      rtcSession.connectionId,
    );
  }

  Future<void> onAnswerReceived(RTCSession rtcSession, Map<String, dynamic> description) async {
    print("onMessage onAnswerReceived  : ${rtcSession.pc?.signalingState}");

    await rtcSession.pc!.setRemoteDescription(
      RTCSessionDescription(
        description['sdp'] as String?,
        description['type'] as String?,
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
      rtcSession.connectionId,
    );
  }

  Future<bool> _send(
    eventType,
    data,
    String remoteCoreId,
    String? remotePeerId,
    connectionId,
  ) async {
    print(
        "onMessage send $remotePeerId : $remoteCoreId : $connectionId : $eventType : $chatId : $data ");
    var request = {};
    request["type"] = eventType;
    request["data"] = data;
    request["command"] = COMMAND;
    request[CONNECTION_ID] = connectionId;

    print("P2PCommunicator: sendingSDP $remoteCoreId : $eventType");
    bool requestSucceeded = await connectionContractor.sendMessage(_encoder.convert(request),
        RemotePeerData(remoteCoreId: remoteCoreId, remotePeerId: remotePeerId));
    print("P2PCommunicator: sendingSDP $remoteCoreId : $eventType : $requestSucceeded");

    return requestSucceeded;
  }

  Future<void> onCandidateReceived(RTCSession rtcSession, Map<String, dynamic> candidateMap) async {
    RTCIceCandidate candidate = RTCIceCandidate(
      candidateMap['candidate'] as String?,
      candidateMap['sdpMid'] as String?,
      candidateMap['sdpMLineIndex'] as int?,
    );
    if (rtcSession.isConnectionStable()) {
      await rtcSession.pc!.addCandidate(candidate);
    } else {
      rtcSession.remoteCandidates.add(candidate);
    }
  }
}
