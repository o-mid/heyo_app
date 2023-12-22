import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:heyo/app/modules/calls/data/rtc/models.dart';
import 'package:heyo/app/modules/calls/data/rtc/session/call_rtc_session.dart';
import 'package:heyo/app/modules/web-rtc/web_rtc_call_connection_manager.dart';

enum CallStatus {
  inComingCall,
  inCall,
  none,
}

class CallStatusProvider {
  CurrentCall? _currentCall;
  RequestedCalls? requestedCalls;
  IncomingCalls? incomingCalls;
  CallStatus callStatus = CallStatus.none;

  CallRTCSession? getConnection(String remoteCoreId, CallId callId) {
    for (final value in _currentCall!.sessions) {
      if (value.callId == callId &&
          value.remotePeer.remoteCoreId == remoteCoreId) {
        return value;
      }
    }
    return null;
  }

  CurrentCall makeCall() {
    final callId = generateCallId();
    callStatus = CallStatus.inCall;
    _currentCall = CurrentCall(callId: callId, sessions: []);
    return _currentCall!;
  }

  void inComingCallReceived(mapData, data, remotePeer) async{
    final callId = mapData['call_id'] as String;
    final isAudioCall = data['isAudioCall'] as bool;
    final members = data['members'] as List<dynamic>;
    final callInfo = CallInfo(
      remotePeer: remotePeer as RemotePeer,
      isAudioCall: isAudioCall,
    );
    /*  if (_incomingCalls?.callId != null && _incomingCalls?.callId == callId) {
    } else if (_incomingCalls != null && _incomingCalls?.callId != callId ||
        _currentCall != null) {
      //TODO busy
    } else if (_incomingCalls?.callId == null) {
    }*/
    List<CallInfo> remotePeers = [callInfo];
    for (var element in members) {
      remotePeers.add(
        CallInfo(
          remotePeer:
          RemotePeer(remotePeerId: null, remoteCoreId: element as String),
          isAudioCall: isAudioCall,
        ),
      );
    }
    incomingCalls =
        IncomingCalls(callId: callId, remotePeers: remotePeers);
/*
    onCallHistoryStatusEvent?.call(
      callId, callInfo, CallHistoryStatus.incoming,);

    onCallStateChange?.call(callId, remotePeers, CallState.callStateRinging);*/
  }
  Future<List<CallRTCSession>> makeCallByIncomingCall(
      MediaStream localStream,) async {
    _currentCall = CurrentCall(callId: incomingCalls!.callId, sessions: []);
    callStatus = CallStatus.inCall;

    for (final element in incomingCalls!.remotePeers) {
      print(
        'accept ${element.remotePeer.remoteCoreId} ${element.isAudioCall}',
      );

      /*    unawaited(singleCallWebRTCBuilder.startSession(
          ,),);*/
      await addSession(
        element.remotePeer,
        localStream,
        element.isAudioCall,
      );
    }
    incomingCalls = null;

    return _currentCall!.sessions;
  }

  void removeSession(CallRTCSession callRTCSession) {
    _currentCall!.sessions.removeWhere(
      (element) =>
          callRTCSession.remotePeer.remoteCoreId ==
          element.remotePeer.remoteCoreId,
    );
  }

  void _addSession(CallRTCSession callRTCSession) {
    _currentCall!.sessions.add(callRTCSession);
  }

  CallId getCurrentCallId() {
    return _currentCall!.callId;
  }

  List<CallRTCSession> getCurrentCallSessions() {
    return _currentCall!.sessions;
  }

  CurrentCall? getCurrentCall() {
    return _currentCall;
  }

  void close() {
    callStatus = CallStatus.none;
    _currentCall = null;
  }

  Future<CallRTCSession> addSession(
      RemotePeer remotePeer, MediaStream localStream, bool isAudioCall,) {
    return _createRTCSession(
        connectionId, remotePeer, localStream, isAudioCall,);
  }

  Future<CallRTCSession> createSession(
    RemotePeer remotePeer,
    bool isAudioCall,
  ) async {
    final rtcSession = CallRTCSession(
      callId: connectionId,
      remotePeer: remotePeer,
      onConnectionFailed: (id, remote) {
        onConnectionFailed?.call(id, remote);
      },
      isAudioCall: isAudioCall,
      onIceCandidate: _sendCandidate,
    );

    localStream.getTracks().forEach((track) {
      rtcSession.pc!.addTrack(track, localStream);
    });
    callRTCSession
      ..onAddRemoteStream = (stream) {
        //TODO refactor
        onCallHistoryStatusEvent?.call(
          callRTCSession.callId,
          CallInfo(remotePeer: remotePeer, isAudioCall: isAudioCall),
          CallHistoryStatus.connected,
        );

        onAddRemoteStream?.call(callRTCSession);
      }
      ..onCameraStateChanged = () {
        onAudioStateChanged?.call(callRTCSession);
      };
    _addSession(callRTCSession);
    return callRTCSession;
  }
/*
  Future<CallRTCSession> _createRTCSession(
    CallId connectionId,
    RemotePeer remotePeer,
    MediaStream localStream,
    bool isAudioCall,
  ) async {
    final rtcSession = CallRTCSession(
      callId: connectionId,
      remotePeer: remotePeer,
      onConnectionFailed: (id, remote) {
        onConnectionFailed?.call(id, remote);
      },
      isAudioCall: isAudioCall,
      onIceCandidate: _sendCandidate,
    );
    rtcSession.pc = await webRTCConnectionManager.createRTCPeerConnection();

    localStream.getTracks().forEach((track) {
      rtcSession.pc!.addTrack(track, localStream);
    });

    return rtcSession;
  }*/
}
