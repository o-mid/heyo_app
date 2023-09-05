import 'dart:convert';

import 'package:heyo/app/modules/p2p_node/p2p_communicator.dart';
import 'package:heyo/app/modules/web-rtc/models.dart';
import 'package:heyo/app/modules/web-rtc/web_rtc_call_connection_manager.dart';

import 'package:flutter_webrtc/flutter_webrtc.dart';

const MEDIA_TYPE = 'video';

const COMMAND = 'call_connection';
const DATA = 'data';

//const initiate = 'initiate';
const DATA_DESCRIPTION = 'description';
const CALL_ID = 'call_id';

class SingleCallWebRTCBuilder {
  final P2PCommunicator p2pCommunicator;
  final WebRTCCallConnectionManager webRTCConnectionManager;
  final JsonEncoder _encoder = const JsonEncoder();
  final JsonDecoder _decoder = const JsonDecoder();
  Function(CallId, String)? onConnectionFailed;
  Function(MediaStream stream)? onAddRemoteStream;
  Function(MediaStream stream)? onRemoveStream;

  SingleCallWebRTCBuilder(
      {required this.p2pCommunicator, required this.webRTCConnectionManager});

  Future<CallRTCSession> _createRTCSession(
      CallId connectionId,
      String remoteCoreId,
      String? remotePeer,
      MediaStream localStream,
      bool isAudioCall) async {
    RTCPeerConnection peerConnection =
        await webRTCConnectionManager.createRTCPeerConnection();
    print("dasdasda1 $isAudioCall");
    CallRTCSession rtcSession = CallRTCSession(
        callId: connectionId,
        remotePeer:
            RemotePeer(remoteCoreId: remoteCoreId, remotePeerId: remotePeer),
        onConnectionFailed: (id, remote) {
          onConnectionFailed?.call(id, remote);
        },
        isAudioCall: isAudioCall);
    print("dasdasda1 ${rtcSession.isAudioCall}");

    rtcSession.pc = peerConnection;
    rtcSession.remotePeer.remotePeerId = remotePeer;
    webRTCConnectionManager.setListeners(
      localStream,
      rtcSession.pc!,
      onAddRemoteStream: (remoteStream) {
        print("onAddRemoteStreammmm1 : ");
        rtcSession.setRemoteStream(remoteStream);
      },
      onIceCandidate: (candidate) => _sendCandidate(candidate, rtcSession),
    );
    return rtcSession;
  }

  Future<CallRTCSession> createSession(CallId connectionId, String remoteCoreId,
      String? remotePeer, MediaStream stream, bool isAudioCall) async {
    return await _createRTCSession(
        connectionId, remoteCoreId, remotePeer, stream, isAudioCall);
  }

  requestSession(CallRTCSession callRTCSession) {
    _send(
      CallSignalingCommands.request,
      {
        "isAudioCall": callRTCSession.isAudioCall,
      },
      callRTCSession.remotePeer.remoteCoreId,
      callRTCSession.remotePeer.remotePeerId,
      callRTCSession.callId,
    );
  }

  Future<bool> startSession(CallRTCSession rtcSession) async {
    print("startSession");
    RTCSessionDescription rtcSessionDescription =
        await webRTCConnectionManager.setupUpOffer(rtcSession.pc!, MEDIA_TYPE);
    print("onMessage send");

    return await _send(
        CallSignalingCommands.offer,
        {
          DATA_DESCRIPTION: {
            'sdp': rtcSessionDescription.sdp,
            'type': rtcSessionDescription.type
          },
          'media': MEDIA_TYPE,
        },
        rtcSession.remotePeer.remoteCoreId,
        rtcSession.remotePeer.remotePeerId,
        rtcSession.callId);
  }

  /*Future<bool> initiateSession(RTCSession rtcSession) async {
    return await _send(initiate, {}, rtcSession.remotePeer.remoteCoreId,
        rtcSession.remotePeer.remotePeerId, rtcSession.connectionId);
  }*/

  Future<void> onOfferReceived(CallRTCSession rtcSession, description) async {
    await rtcSession.pc!.setRemoteDescription(
        RTCSessionDescription(description['sdp'], description['type']));

    RTCSessionDescription sessionDescription =
        await webRTCConnectionManager.setupAnswer(rtcSession.pc!, MEDIA_TYPE);
    print("onMessage onOfferReceived Send");


    _send(
        CallSignalingCommands.answer,
        {
          'description': {
            'sdp': sessionDescription.sdp,
            'type': sessionDescription.type
          },
        },
        rtcSession.remotePeer.remoteCoreId,
        rtcSession.remotePeer.remotePeerId,
        rtcSession.callId);
  }

  Future<void> onAnswerReceived(CallRTCSession rtcSession, description) async {
    print("onMessage onAnswerReceived  : ${rtcSession.pc?.signalingState}");

    await rtcSession.pc!.setRemoteDescription(
      RTCSessionDescription(
        description['sdp'],
        description['type'],
      ),
    );
  }
  void reject(String callId, RemotePeer remotePeer) {
    _send(
        CallSignalingCommands.reject,
        {

        },
        remotePeer.remoteCoreId,
        remotePeer.remotePeerId,
        callId);
  }

  _sendCandidate(RTCIceCandidate iceCandidate, CallRTCSession rtcSession) {
    _send(
        CallSignalingCommands.candidate,
        {
          CallSignalingCommands.candidate: {
            'sdpMLineIndex': iceCandidate.sdpMLineIndex,
            'sdpMid': iceCandidate.sdpMid,
            'candidate': iceCandidate.candidate,
          },
        },
        rtcSession.remotePeer.remoteCoreId,
        rtcSession.remotePeer.remotePeerId,
        rtcSession.callId);
  }

  Future<bool> _send(
      eventType, data, remoteCoreId, remotePeerId, connectionId) async {
    print(
        "onMessage send $remotePeerId : $remoteCoreId : $connectionId : $eventType : $data ");
    var request = {};
    request["type"] = eventType;
    request["data"] = data;
    request["command"] = COMMAND;
    request[CALL_ID] = connectionId;
    print("P2PCommunicator: sendingSDP $remoteCoreId : $eventType");
    bool requestSucceeded = await p2pCommunicator.sendSDP(
        _encoder.convert(request), remoteCoreId, remotePeerId);
    print(
        "P2PCommunicator: sendingSDP $remoteCoreId : $eventType : $requestSucceeded");

    return requestSucceeded;
  }

  Future<void> onCandidateReceived(
      CallRTCSession rtcSession, candidateMap) async {
    RTCIceCandidate candidate = RTCIceCandidate(
      candidateMap['candidate'],
      candidateMap['sdpMid'],
      candidateMap['sdpMLineIndex'],
    );
  /*  if (rtcSession.isConnectionStable()) {
      await rtcSession.pc!.addCandidate(candidate);
    } else {
      rtcSession.remoteCandidates.add(candidate);
    }*/
    await rtcSession.pc!.addCandidate(candidate);
  }

}
