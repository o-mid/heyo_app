import 'dart:async';
import 'dart:convert';

import 'package:heyo/app/modules/connection/domain/connection_contractor.dart';
import 'package:heyo/app/modules/connection/domain/connection_models.dart';
import 'package:heyo/app/modules/web-rtc/web_rtc_call_connection_manager.dart';

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:heyo/modules/call/data/rtc/models.dart';
import 'package:heyo/modules/call/data/rtc/session/call_rtc_session.dart';

const MEDIA_TYPE = 'video';

const COMMAND = 'call_connection';
const DATA = 'data';

//const initiate = 'initiate';
const DATA_DESCRIPTION = 'description';
const CALL_ID = 'call_id';

class SingleCallWebRTCBuilder {
  SingleCallWebRTCBuilder({
    required this.connectionContractor,
  });
  final ConnectionContractor connectionContractor;
  final JsonEncoder _encoder = const JsonEncoder();
  final JsonDecoder _decoder = const JsonDecoder();
  Function(CallId, String)? onConnectionFailed;
  Function(MediaStream stream)? onAddRemoteStream;
  Function(MediaStream stream)? onRemoveStream;

  void requestCall(
    CallId callId,
    RemotePeer remotePeer,
    bool isAudioCall,
    List<String> members,
  ) {
    members.removeWhere(
      (element) => element == remotePeer.remoteCoreId,
    );
    _send(
      CallSignalingCommands.request,
      {'isAudioCall': isAudioCall, 'members': members},
      remotePeer.remoteCoreId,
      remotePeer.remotePeerId,
      callId,
    );
  }

  Future<bool> startSession(CallRTCSession rtcSession) async {
    print("startSession");
    final rtcSessionDescription = await WebRTCCallConnectionManager.setupUpOffer(rtcSession.pc!);
    print("onMessage send");

    return _send(
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
    final sessionDescription = await rtcSession.onOfferReceived(
      description['sdp'] as String?,
      description['type'] as String?,
    );
    print('onMessage onOfferReceived Send');

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
    await rtcSession.onAnswerReceived(
      description['sdp'] as String?,
      description['type'] as String?,
    );
  }

  Future<void> reject(String callId, RemotePeer remotePeer) async {
    unawaited(_send(
      CallSignalingCommands.reject,
      {},
      remotePeer.remoteCoreId,
      remotePeer.remotePeerId,
      callId,
    ));
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
    final requestSucceeded = await connectionContractor.sendMessage(_encoder.convert(request),
        RemotePeerData(remoteCoreId: remoteCoreId, remotePeerId: remotePeerId));
    print(
      "P2PCommunicator: sendingSDP $remoteCoreId : $eventType : $requestSucceeded",
    );

    return requestSucceeded;
  }

  Future<void> onCandidateReceived(
    CallRTCSession rtcSession,
    candidateMap,
  ) async {
    final candidate = RTCIceCandidate(
      candidateMap['candidate'] as String?,
      candidateMap['sdpMid'] as String?,
      candidateMap['sdpMLineIndex'] as int?,
    );
    await rtcSession.pc!.addCandidate(candidate);
  }

  void addMemberEvent(String member, CallRTCSession rtcSession) {
    _send(
      CallSignalingCommands.newMember,
      {
        CallSignalingCommands.newMember: {'member': member},
      },
      rtcSession.remotePeer.remoteCoreId,
      rtcSession.remotePeer.remotePeerId,
      rtcSession.callId,
    );
  }

  void updateCamera(bool value, CallRTCSession callRTCSession) {
    _send(
      CallSignalingCommands.cameraStateChanged,
      {
        CallSignalingCommands.cameraStateChanged: {'cameraStateChanged': value},
      },
      callRTCSession.remotePeer.remoteCoreId,
      callRTCSession.remotePeer.remotePeerId,
      callRTCSession.callId,
    );
  }
}
