import 'dart:convert';

import 'package:heyo/app/modules/connection/domain/connection_contractor.dart';
import 'package:heyo/app/modules/connection/domain/connection_models.dart';
import 'package:heyo/app/modules/p2p_node/p2p_communicator.dart';
import 'package:heyo/app/modules/calls/data/models.dart';
import 'package:heyo/app/modules/web-rtc/web_rtc_call_connection_manager.dart';

import 'package:flutter_webrtc/flutter_webrtc.dart';

const MEDIA_TYPE = 'video';

const COMMAND = 'call_connection';
const DATA = 'data';

//const initiate = 'initiate';
const DATA_DESCRIPTION = 'description';
const CALL_ID = 'call_id';

class SingleCallWebRTCBuilder {
  final ConnectionContractor connectionContractor;
  final WebRTCCallConnectionManager webRTCConnectionManager;
  final JsonEncoder _encoder = const JsonEncoder();
  final JsonDecoder _decoder = const JsonDecoder();
  Function(CallId, String)? onConnectionFailed;
  Function(MediaStream stream)? onAddRemoteStream;
  Function(MediaStream stream)? onRemoveStream;

  SingleCallWebRTCBuilder({
    required this.connectionContractor,
    required this.webRTCConnectionManager,
  });

  Future<CallRTCSession> _createRTCSession(
    CallId connectionId,
    RemotePeer remotePeer,
    MediaStream localStream,
    bool isAudioCall,
  ) async {
    RTCPeerConnection peerConnection =
        await webRTCConnectionManager.createRTCPeerConnection();
    CallRTCSession rtcSession = CallRTCSession(
      callId: connectionId,
      remotePeer: remotePeer,
      onConnectionFailed: (id, remote) {
        onConnectionFailed?.call(id, remote);
      },
      isAudioCall: isAudioCall,
    );

    rtcSession.pc = peerConnection;
    webRTCConnectionManager.setListeners(
      localStream,
      rtcSession.pc!,
      onAddRemoteStream: (remoteStream) {
        rtcSession.setRemoteStream(remoteStream);
      },
      onIceCandidate: (candidate) => _sendCandidate(candidate, rtcSession),
    );
    return rtcSession;
  }

  Future<CallRTCSession> createSession(
    CallId connectionId,
    RemotePeer remotePeer,
    MediaStream stream,
    bool isAudioCall,
  ) async {
    return await _createRTCSession(
      connectionId,
      remotePeer,
      stream,
      isAudioCall,
    );
  }

  requestSession(CallRTCSession callRTCSession, List<String> members) {
    members.removeWhere(
      (element) => element == callRTCSession.remotePeer.remoteCoreId,
    );
    _send(
      CallSignalingCommands.request,
      {"isAudioCall": callRTCSession.isAudioCall, "members": members},
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
          'type': rtcSessionDescription.type,
        },
        'media': MEDIA_TYPE,
      },
      rtcSession.remotePeer.remoteCoreId,
      rtcSession.remotePeer.remotePeerId,
      rtcSession.callId,
    );
  }

  Future<void> onOfferReceived(CallRTCSession rtcSession, description) async {
    await rtcSession.pc!.setRemoteDescription(
      RTCSessionDescription(
        description['sdp'] as String?,
        description['type'] as String?,
      ),
    );

    RTCSessionDescription sessionDescription =
        await webRTCConnectionManager.setupAnswer(rtcSession.pc!, MEDIA_TYPE);
    print("onMessage onOfferReceived Send");

    _send(
      CallSignalingCommands.answer,
      {
        'description': {
          'sdp': sessionDescription.sdp,
          'type': sessionDescription.type,
        },
      },
      rtcSession.remotePeer.remoteCoreId,
      rtcSession.remotePeer.remotePeerId,
      rtcSession.callId,
    );
  }

  Future<void> onAnswerReceived(CallRTCSession rtcSession, description) async {
    print("onMessage onAnswerReceived  : ${rtcSession.pc?.signalingState}");

    await rtcSession.pc!.setRemoteDescription(
      RTCSessionDescription(
        description['sdp'] as String?,
        description['type'] as String?,
      ),
    );
  }

  void reject(String callId, RemotePeer remotePeer) {
    _send(
      CallSignalingCommands.reject,
      {},
      remotePeer.remoteCoreId,
      remotePeer.remotePeerId,
      callId,
    );
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
      rtcSession.callId,
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
      "onMessage send $remotePeerId : $remoteCoreId : $connectionId : $eventType : $data ",
    );
    var request = {};
    request["type"] = eventType;
    request["data"] = data;
    request["command"] = COMMAND;
    request[CALL_ID] = connectionId;
    print("P2PCommunicator: sendingSDP $remoteCoreId : $eventType");
    final requestSucceeded = await connectionContractor.sendMessage(
      _encoder.convert(request),
      RemotePeerData(remoteCoreId: remoteCoreId, remotePeerId: remotePeerId)
    );
    print(
      "P2PCommunicator: sendingSDP $remoteCoreId : $eventType : $requestSucceeded",
    );

    return requestSucceeded;
  }

  Future<void> onCandidateReceived(
    CallRTCSession rtcSession,
    candidateMap,
  ) async {
    RTCIceCandidate candidate = RTCIceCandidate(
      candidateMap['candidate'] as String?,
      candidateMap['sdpMid'] as String?,
      candidateMap['sdpMLineIndex'] as int?,
    );
    await rtcSession.pc!.addCandidate(candidate);
  }

  Future<MediaStream> createStream(String media, bool userScreen) async {
    return await webRTCConnectionManager.createStream(media, userScreen);
  }

  void addMemberEvent(String member, CallRTCSession rtcSession) {
    _send(
      CallSignalingCommands.newMember,
      {
        CallSignalingCommands.newMember: {member},
      },
      rtcSession.remotePeer.remoteCoreId,
      rtcSession.remotePeer.remotePeerId,
      rtcSession.callId,
    );
  }
}
