import 'dart:convert';

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/messaging/models.dart';
import 'package:heyo/app/modules/messaging/web_rtc_connection_manager.dart';
import 'package:heyo/app/modules/p2p_node/p2p_communicator.dart';

const MEDIA_TYPE = 'data';

const COMMAND = 'multiple_connection';
const DATA = 'data';

const candidate = 'candidate';
const offer = 'offer';
const answer = 'answer';
const DATA_DESCRIPTION = 'description';

class SingleWebRTCConnection {
  final P2PCommunicator p2pCommunicator;
  final WebRTCConnectionManager webRTCConnectionManager;
  final JsonEncoder _encoder = const JsonEncoder();
  final JsonDecoder _decoder = const JsonDecoder();

  SingleWebRTCConnection(
      {required this.p2pCommunicator, required this.webRTCConnectionManager});

  Future<RTCSession> _createRTCSession(
      String remoteCoreId, String? remotePeerId) async {
    //SendWEBRTC
    RTCPeerConnection peerConnection =
        await webRTCConnectionManager.createRTCPeerConnection();
    RTCSession rtcSession = RTCSession(
        remotePeer:
            RemotePeer(remoteCoreId: remoteCoreId, remotePeerId: remotePeerId));
    rtcSession.pc = peerConnection;

    webRTCConnectionManager.setListeners( rtcSession.pc!,
        onIceCandidate: (candidate) => _sendCandidate(candidate, rtcSession));
    return rtcSession;
  }

  Future<RTCSession> createSession(
      String remoteCoreId, String? remotePeerId) async {
    return await _createRTCSession(remoteCoreId, remotePeerId);
  }

  Future<bool> startSession(RTCSession rtcSession) async {
    RTCSessionDescription rtcSessionDescription =
        await webRTCConnectionManager.setupUpOffer(rtcSession.pc!, MEDIA_TYPE);

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
    );
  }

  void onOfferReceived(RTCSession rtcSession, description) async {
    await rtcSession.pc!.setRemoteDescription(
        RTCSessionDescription(description['sdp'], description['type']));
    RTCSessionDescription sessionDescription =
        await webRTCConnectionManager.setupAnswer(rtcSession.pc!, MEDIA_TYPE);

    var completed = await _send(
        answer,
        {
          'description': {
            'sdp': sessionDescription.sdp,
            'type': sessionDescription.type
          },
        },
        rtcSession.remotePeer.remoteCoreId,
        rtcSession.remotePeer.remotePeerId);
  }

  void onAnswerReceived(RTCSession rtcSession, description) async {
      await rtcSession.pc!.setRemoteDescription(
        RTCSessionDescription(
          description['sdp'],
          description['type'],
        ),
      );


  }

   _sendCandidate(
      RTCIceCandidate iceCandidate, RTCSession rtcSession)  {
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
        rtcSession.remotePeer.remotePeerId);
  }

  Future<bool> _send(eventType, data, remoteCoreId, remotePeerId) async {
    var request = {};
    request["type"] = eventType;
    request["data"] = data;
    request["command"] = COMMAND;
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
