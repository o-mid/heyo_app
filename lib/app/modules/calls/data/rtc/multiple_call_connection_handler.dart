import 'dart:async';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:heyo/app/modules/calls/data/call_status_provider.dart';
import 'package:heyo/app/modules/calls/data/rtc/models.dart';
import 'package:heyo/app/modules/calls/data/rtc/session/call_rtc_session.dart';
import 'package:heyo/app/modules/calls/shared/data/models/all_participant_model/all_participant_model.dart';
import 'package:heyo/app/modules/calls/data/rtc/single_call_web_rtc_connection.dart';
import 'package:heyo/app/modules/web-rtc/web_rtc_call_connection_manager.dart';

enum CallState {
  callStateConnected,
  callStateRemoved,
  callStateRinging,
  callStateBye,
  callStateBusy
}

class CallConnectionsHandler {
  CallConnectionsHandler({
    required this.singleCallWebRTCBuilder,
    required this.callStatusProvider,
  });

  SingleCallWebRTCBuilder singleCallWebRTCBuilder;
  MediaStream? _localStream;
  Function(MediaStream stream)? onLocalStream;
  Function(CallRTCSession callRTCSession)? onAddRemoteStream;

  Function(AllParticipantModel participate)? onChangeParticipateStream;
  Function(CallRTCSession callRTCSession)? onAudioStateChanged;

  final CallStatusProvider callStatusProvider;
  Function(CallId callId, List<CallInfo> callInfo, CallState state)?
      onCallStateChange;

  Function(CallId callId, CallInfo callInfo, CallHistoryStatus status)?
      onCallHistoryStatusEvent;

  Future<void> addMember(String remoteCoreId) async {
    for (var element in callStatusProvider.getCurrentCallSessions()) {
      print("addMemberEvent : $remoteCoreId");
      singleCallWebRTCBuilder.addMemberEvent(remoteCoreId, element);
    }
    //TODO refactor isAudio
    final callRTCSession = await callStatusProvider.addSession(
        RemotePeer(
          remoteCoreId: remoteCoreId,
          remotePeerId: null,
        ),
        _localStream!,
        callStatusProvider.getCurrentCallSessions().first.isAudioCall,
        callStatusProvider.incomingCalls!.callId);
    singleCallWebRTCBuilder.requestCall(
      callRTCSession.callId,
      RemotePeer(remoteCoreId: remoteCoreId, remotePeerId: null),
      callStatusProvider.getCurrentCallSessions().first.isAudioCall,
      callStatusProvider
          .getCurrentCallSessions()
          .map((e) => e.remotePeer.remoteCoreId)
          .toList(),
    );
  }

  Future<CallRTCSession> createCall(
    String remoteCoreId,
    bool isAudioCall,
  ) async {
    await _createLocalStream();

    final callId = callStatusProvider.makeCall().callId;
    final callRTCSession = await callStatusProvider.addSession(
        RemotePeer(remoteCoreId: remoteCoreId, remotePeerId: null),
        _localStream!,
        isAudioCall,
        callId);
    singleCallWebRTCBuilder
        .requestCall(callId, callRTCSession.remotePeer, isAudioCall, []);
    final callInfo = CallInfo(
      remotePeer: RemotePeer(remoteCoreId: remoteCoreId, remotePeerId: null),
      isAudioCall: isAudioCall,
    );

    onCallHistoryStatusEvent?.call(callId, callInfo, CallHistoryStatus.calling);
    //generate a connectionId
    //send requestCall
    return callRTCSession;
  }

  Future<void> _createLocalStream() async {
    if (_localStream == null) {
      _localStream =
          await WebRTCCallConnectionManager.createStream('video', false);
      onLocalStream?.call(_localStream!);
    }
  }

/*
  Future<CallRTCSession> _createSession(
    RemotePeer remotePeer,
    bool isAudioCall,
  ) async {
    final callRTCSession = await singleCallWebRTCBuilder.createSession(
      callStatusProvider.getCurrentCallId(),
      remotePeer,
      _localStream!,
      isAudioCall,
    );
    callRTCSession
      ..onAddRemoteStream = (stream) {
        //TODO refactor
        onCallHistoryStatusEvent?.call(
            callRTCSession.callId,
            CallInfo(remotePeer: remotePeer, isAudioCall: isAudioCall),
            CallHistoryStatus.connected,);

        onAddRemoteStream?.call(callRTCSession);
      }
      ..onCameraStateChanged = () {
        onAudioStateChanged?.call(callRTCSession);
      };
    callStatusProvider.addSession(callRTCSession);
    return callRTCSession;
  }
*/

  Future<void> accept(CallId callId) async {
    print('accept ${callStatusProvider.incomingCalls}');
    if (callStatusProvider.incomingCalls?.callId == callId) {
      await _createLocalStream();
      final sessions =
          await callStatusProvider.makeCallByIncomingCall(_localStream!);
      for (final element in sessions) {
        unawaited(singleCallWebRTCBuilder.startSession(element));
      }
    }
  }

  Future<void> reject(String callId) async {
    if (callStatusProvider.getCurrentCall()?.callId == callId) {
      for (final element in callStatusProvider.getCurrentCallSessions()) {
        await singleCallWebRTCBuilder.reject(callId, element.remotePeer);
      }
      callStatusProvider.close();
    }
  }

  Future<void> close() async {
    if (_localStream != null) {
      for (final element in _localStream!.getTracks()) {
        await element.stop();
      }
      await _localStream?.dispose();
      _localStream = null;
    }

    if (callStatusProvider.getCurrentCall() != null) {
      for (final element in callStatusProvider.getCurrentCall()!.sessions) {
        await element.dispose();
      }
      callStatusProvider.getCurrentCall()!.sessions.clear();
      callStatusProvider.close();
    }
  }

  void onNewMemberEventReceived(CallId callId, dynamic data) async {
    final member = data["newMemer"] as Map<String, dynamic>;
    if (callId == callStatusProvider.getCurrentCall()?.callId) {
      await callStatusProvider.addSession(
          RemotePeer(
            remoteCoreId: member["member"] as String,
            remotePeerId: null,
          ),
          _localStream!,
          callStatusProvider.getCurrentCall()!.sessions.first.isAudioCall,
          callId);
    }
  }

  void onCallCandidateReceived(
    CallId callId,
    RemotePeer remotePeer,
    dynamic data,
  ) {
    final rtcSession =
        callStatusProvider.getConnection(remotePeer.remoteCoreId, callId)!;
    rtcSession.remotePeer.remotePeerId ??= remotePeer.remotePeerId;

    final candidateMap = data[CallSignalingCommands.candidate];
    singleCallWebRTCBuilder.onCandidateReceived(rtcSession, candidateMap);
  }

  void onCallAnswerReceived(
    CallId callId,
    RemotePeer remotePeer,
    dynamic data,
  ) {
    final rtcSession =
        callStatusProvider.getConnection(remotePeer.remoteCoreId, callId)!;
    rtcSession.remotePeer.remotePeerId ??= remotePeer.remotePeerId;
    final description = data[DATA_DESCRIPTION];
    singleCallWebRTCBuilder.onAnswerReceived(rtcSession, description);
  }

  void onCallOfferReceived(
    CallId callId,
    RemotePeer remotePeer,
    dynamic data,
  ) {
    final description = data[DATA_DESCRIPTION];
    final rtcSession =
        callStatusProvider.getConnection(remotePeer.remoteCoreId, callId)!;
    rtcSession.remotePeer.remotePeerId ??= remotePeer.remotePeerId;

    singleCallWebRTCBuilder.onOfferReceived(rtcSession, description);
  }

  void switchCamera() {
    if (_localStream != null) {
      Helper.switchCamera(_localStream!.getVideoTracks()[0]);
    }
  }

  void muteMic() {
    if (_localStream != null) {
      bool enabled = _localStream!.getAudioTracks()[0].enabled;
      _localStream!.getAudioTracks()[0].enabled = !enabled;
    }
  }

  void showLocalVideoStream(bool videMode, bool sendSignal) {
    if (sendSignal) {
      for (var element in callStatusProvider.getCurrentCall()!.sessions) {
        singleCallWebRTCBuilder.updateCamera(videMode, element);
      }
    }
    if (_localStream != null) {
      _localStream!.getVideoTracks()[0].enabled = videMode;
    }
  }

  void peerOpendCamera(String sessionId) {}

  void peerClosedCamera(String sessionId) {}

  Future<void> onCallRequestRejected(mapData, RemotePeer remotePeer) async {
    String callId = mapData[CALL_ID] as String;
    if (callStatusProvider.getCurrentCall() != null) {
      final callRTCSession =
          callStatusProvider.getConnection(remotePeer.remoteCoreId, callId);
      if (callRTCSession != null) {
        //TODO update based on..

        await callRTCSession.dispose();
        callStatusProvider.getCurrentCall()?.sessions.removeWhere(
              (element) =>
                  element.remotePeer.remoteCoreId == remotePeer.remoteCoreId,
            );
        onCallStateChange?.call(
          callId,
          [
            CallInfo(
              remotePeer: callRTCSession.remotePeer,
              isAudioCall: callRTCSession.isAudioCall,
            ),
          ],
          CallState.callStateBye,
        );
      }
    }
    if (callStatusProvider.incomingCalls != null) {
      onCallStateChange?.call(
        callId,
        [callStatusProvider.incomingCalls!.remotePeers.first],
        CallState.callStateBye,
      );
      callStatusProvider.incomingCalls = null;
    }
  }

  void rejectIncomingCall(String callId) {
    if (callStatusProvider.incomingCalls?.callId == callId) {
      for (final element in callStatusProvider.incomingCalls!.remotePeers) {
        singleCallWebRTCBuilder.reject(callId, element.remotePeer);
      }
      callStatusProvider.incomingCalls = null;
    }
  }

  List<CallRTCSession> getRemoteStreams() {
    return callStatusProvider.getCurrentCall()!.sessions;
  }

  MediaStream? getLocalStream() {
    return _localStream;
  }

  void onCameraStateChanged(String callId, data, RemotePeer remotePeer) {
    final cameraState = data["cameraStateChanged"] as Map<String, dynamic>;
    if (callId == callStatusProvider.getCurrentCall()?.callId) {
      final isVideMode = cameraState["cameraStateChanged"] as bool;
      callStatusProvider.getCurrentCall()?.sessions.forEach((element) {
        if (element.remotePeer.remoteCoreId == remotePeer.remoteCoreId) {
          element.setCameraState(!isVideMode);
        }
      });
    }
  }
}
