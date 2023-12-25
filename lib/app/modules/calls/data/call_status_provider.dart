import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:heyo/app/modules/calls/data/rtc/models.dart';
import 'package:heyo/app/modules/calls/data/rtc/multiple_call_connection_handler.dart';
import 'package:heyo/app/modules/calls/data/rtc/session/call_rtc_session.dart';
import 'package:heyo/app/modules/calls/data/signaling/call_signaling.dart';
import 'package:heyo/app/modules/web-rtc/web_rtc_call_connection_manager.dart';

enum CurrentCallStatus {
  inComingCall,
  inCall,
  none,
}

enum CallHistoryStatus { incoming, calling, connected, left, end }

class CallStatusProvider {
  CallStatusProvider({required this.callSignaling});

  CurrentCall? _currentCall;
  RequestedCalls? requestedCalls;
  IncomingCalls? incomingCalls;
  CallSignaling callSignaling;
  CurrentCallStatus callStatus = CurrentCallStatus.none;
  Function(CallId callId, List<CallInfo> callInfo, CurrentCallStatus state)?
      onCallStateChange;

  Function(CallId callId, CallInfo callInfo, CallHistoryStatus status)?
      onCallHistoryStatusEvent;

  CallRTCSession? getConnection(String remoteCoreId, CallId callId) {
    for (final value in _currentCall!.sessions) {
      if (value.callId == callId &&
          value.remotePeer.remoteCoreId == remoteCoreId) {
        return value;
      }
    }
    return null;
  }

  Future<CallRTCSession> makeCall(
      String remoteCoreId,
      MediaStream localStream,
      bool isAudioCall,) async {
    final callId = generateCallId();
    callStatus = CurrentCallStatus.inCall;
    _currentCall = CurrentCall(callId: callId, sessions: []);

    final callRTCSession = await addSession(
      RemotePeer(remoteCoreId: remoteCoreId, remotePeerId: null),
      localStream,
      isAudioCall,
      callId,
    );

    callSignaling
        .requestCall(callId, callRTCSession.remotePeer, isAudioCall, []);
    final callInfo = CallInfo(
      remotePeer: RemotePeer(remoteCoreId: remoteCoreId, remotePeerId: null),
      isAudioCall: isAudioCall,
    );

    onCallHistoryStatusEvent?.call(callId, callInfo, CallHistoryStatus.calling);

    return callRTCSession;
  }

  Future<void> inComingCallReceived(mapData, data, remotePeer) async {
    callStatus = CurrentCallStatus.inComingCall;
    final callId = mapData['call_id'] as String;
    final isAudioCall = data['isAudioCall'] as bool;
    final members = data['members'] as List<dynamic>;
    final callInfo = CallInfo(
      remotePeer: remotePeer as RemotePeer,
      isAudioCall: isAudioCall,
    );

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

    incomingCalls = IncomingCalls(callId: callId, remotePeers: remotePeers);

    onCallStateChange?.call(
        callId, remotePeers, CurrentCallStatus.inComingCall);
/*
    onCallHistoryStatusEvent?.call(
      callId, callInfo, CallHistoryStatus.incoming,);

    onCallStateChange?.call(callId, remotePeers, CallState.callStateRinging);*/
  }

  Future<List<CallRTCSession>> makeCallByIncomingCall(
    MediaStream localStream,
  ) async {
    _currentCall = CurrentCall(callId: incomingCalls!.callId, sessions: []);
    callStatus = CurrentCallStatus.inCall;

    for (final element in incomingCalls!.remotePeers) {
      print(
        'accept ${element.remotePeer.remoteCoreId} ${element.isAudioCall}',
      );

      /*    unawaited(singleCallWebRTCBuilder.startSession(
          ,),);*/
      final callRTCSession = await addSession(
        element.remotePeer,
        localStream,
        element.isAudioCall,
        incomingCalls!.callId
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
    callStatus = CurrentCallStatus.none;
    _currentCall = null;
  }

  Future<CallRTCSession> addSession(
    RemotePeer remotePeer,
    MediaStream localStream,
    bool isAudioCall,
    String connectionId,
  ) async {
    final callRTCSession = await CallRTCSession.createCallRTCSession(
      remotePeer,
      localStream,
      isAudioCall,
      connectionId,
      (candidate, callRTCSession) =>
          {callSignaling.sendCandidate(candidate, callRTCSession)},
    );
    _addSession(callRTCSession);
    return callRTCSession;
  }
}
