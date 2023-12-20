import 'dart:async';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:heyo/app/modules/calls/data/call_status_data_store.dart';
import 'package:heyo/app/modules/calls/data/rtc/models.dart';
import 'package:heyo/app/modules/calls/data/rtc/session/call_rtc_session.dart';
import 'package:heyo/app/modules/calls/shared/data/models/all_participant_model/all_participant_model.dart';
import 'package:heyo/app/modules/calls/data/rtc/single_call_web_rtc_connection.dart';
import 'package:heyo/app/modules/shared/data/models/call_history_status.dart';

enum CallState {
  callStateNew,
  callStateRinging,
  callStateInvite,
  callStateConnected,
  callStateBye,
  callStateBusy
}

enum CallHistoryStatus { incoming, calling, connected, left, end }

class CallConnectionsHandler {
  SingleCallWebRTCBuilder singleCallWebRTCBuilder;
  MediaStream? _localStream;
  Function(MediaStream stream)? onLocalStream;
  Function(CallRTCSession callRTCSession)? onAddRemoteStream;

  Function(AllParticipantModel participate)? onChangeParticipateStream;
  Function(CallRTCSession callRTCSession)? onAudioStateChanged;

  CallConnectionsHandler({
    required this.singleCallWebRTCBuilder,
    required this.callStatusDataStore,
  });

  final CallStatusDataStore callStatusDataStore;
  Function(CallId callId, List<CallInfo> callInfo, CallState state)?
      onCallStateChange;

  Function(CallId callId, CallInfo callInfo, CallHistoryStatus status)?
      onCallHistoryStatusEvent;

  Future<void> addMember(String remoteCoreId) async {
    for (var element in callStatusDataStore.currentCall!.sessions) {
      print("addMemberEvent : $remoteCoreId");
      singleCallWebRTCBuilder.addMemberEvent(remoteCoreId, element);
    }
    //TODO refactor isAudio
    final callRTCSession = await _createSession(
      RemotePeer(
        remoteCoreId: remoteCoreId,
        remotePeerId: null,
      ),
      callStatusDataStore.currentCall!.sessions.first.isAudioCall,
    );
    singleCallWebRTCBuilder.requestSession(
      callRTCSession,
      callStatusDataStore.currentCall!.sessions
          .map((e) => e.remotePeer.remoteCoreId)
          .toList(),
    );
  }

  Future<CallRTCSession> createCall(
    String remoteCoreId,
    bool isAudioCall,
  ) async {
    final callId = callStatusDataStore.makeCall().callId;
    await _createLocalStream();
    final callRTCSession = await _createSession(
      RemotePeer(remoteCoreId: remoteCoreId, remotePeerId: null),
      isAudioCall,
    );
    singleCallWebRTCBuilder.requestSession(callRTCSession, []);
    final callInfo = CallInfo(
      remotePeer: RemotePeer(remoteCoreId: remoteCoreId, remotePeerId: null),
      isAudioCall: isAudioCall,
    );
    onCallStateChange?.call(callId, [callInfo], CallState.callStateNew);
    onCallStateChange?.call(callId, [callInfo], CallState.callStateInvite);

    onCallHistoryStatusEvent?.call(callId, callInfo, CallHistoryStatus.calling);
    //generate a connectionId
    //send requestCall
    return callRTCSession;
  }

  Future<void> _createLocalStream() async {
    if (_localStream == null) {
      _localStream = await singleCallWebRTCBuilder.createStream('video', false);
      onLocalStream?.call(_localStream!);
    }
  }

  Future<CallRTCSession> _createSession(
    RemotePeer remotePeer,
    bool isAudioCall,
  ) async {
    final callRTCSession = await singleCallWebRTCBuilder.createSession(
      callStatusDataStore.currentCall!.callId,
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
            CallHistoryStatus.connected);

        onAddRemoteStream?.call(callRTCSession);
      }
      ..onCameraStateChanged = () {
        onAudioStateChanged?.call(callRTCSession);
      };
    callStatusDataStore.addSession(callRTCSession);
    return callRTCSession;
  }

  Future<void> accept(CallId callId) async {
    print('accept ${callStatusDataStore.incomingCalls}');
    if (callStatusDataStore.incomingCalls?.callId == callId) {
      callStatusDataStore.makeCallByIncomingCall();
      await _createLocalStream();

      for (final element in callStatusDataStore.incomingCalls!.remotePeers) {
        print(
          'accept ${element.remotePeer.remoteCoreId} ${element.isAudioCall}',
        );
        final callRTCSession =
            await _createSession(element.remotePeer, element.isAudioCall);
        unawaited(singleCallWebRTCBuilder.startSession(callRTCSession));
      }

      onCallStateChange?.call(
        callId,
        callStatusDataStore.incomingCalls!.remotePeers,
        CallState.callStateConnected,
      );
    }
  }

  Future<void> reject(String callId) async {
    if (callStatusDataStore.currentCall?.callId == callId) {
      for (final element in callStatusDataStore.currentCall!.sessions) {
        await singleCallWebRTCBuilder.reject(callId, element.remotePeer);
      }
      callStatusDataStore.currentCall = null;
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

    if (callStatusDataStore.currentCall != null) {
      for (final element in callStatusDataStore.currentCall!.sessions) {
        await element.dispose();
      }
      callStatusDataStore.currentCall!.sessions.clear();
      callStatusDataStore.currentCall = null;
    }
  }

  void onNewMemberEventReceived(CallId callId, dynamic data) async {
    final member = data["newMemer"] as Map<String, dynamic>;
    if (callId == callStatusDataStore.currentCall?.callId) {
      await _createSession(
        RemotePeer(
          remoteCoreId: member["member"] as String,
          remotePeerId: null,
        ),
        callStatusDataStore.currentCall!.sessions.first.isAudioCall,
      );
    }
  }

  void onCallCandidateReceived(
      CallId callId, RemotePeer remotePeer, dynamic data) {
    final rtcSession =
        callStatusDataStore.getConnection(remotePeer.remoteCoreId, callId)!;
    rtcSession.remotePeer.remotePeerId ??= remotePeer.remotePeerId;

    final candidateMap = data[CallSignalingCommands.candidate];
    singleCallWebRTCBuilder.onCandidateReceived(rtcSession, candidateMap);
  }

  void onCallAnswerReceived(
      CallId callId, RemotePeer remotePeer, dynamic data) {
    final rtcSession =
        callStatusDataStore.getConnection(remotePeer.remoteCoreId, callId)!;
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
        callStatusDataStore.getConnection(remotePeer.remoteCoreId, callId)!;
    rtcSession.remotePeer.remotePeerId ??= remotePeer.remotePeerId;

    onCallStateChange?.call(
      callId,
      [
        CallInfo(
          remotePeer: rtcSession.remotePeer,
          isAudioCall: rtcSession.isAudioCall,
        ),
      ],
      CallState.callStateConnected,
    );

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
      for (var element in callStatusDataStore.currentCall!.sessions) {
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
    if (callStatusDataStore.currentCall != null) {
      final callRTCSession =
          callStatusDataStore.getConnection(remotePeer.remoteCoreId, callId);
      if (callRTCSession != null) {
        //TODO update based on..

        await callRTCSession.dispose();
        callStatusDataStore.currentCall?.sessions.removeWhere(
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
    if (callStatusDataStore.incomingCalls != null) {
      onCallStateChange?.call(
        callId,
        [callStatusDataStore.incomingCalls!.remotePeers.first],
        CallState.callStateBye,
      );
      callStatusDataStore.incomingCalls = null;
    }
  }

  void onCallRequestReceived(mapData, data, remotePeer) {
    final callId = mapData[CALL_ID] as String;
    final isAudioCall = data["isAudioCall"] as bool;
    final members = data["members"] as List<dynamic>;
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
    callStatusDataStore.incomingCalls =
        IncomingCalls(callId: callId, remotePeers: remotePeers);

    onCallHistoryStatusEvent?.call(
        callId, callInfo, CallHistoryStatus.incoming);

    onCallStateChange?.call(callId, remotePeers, CallState.callStateNew);

    onCallStateChange?.call(callId, remotePeers, CallState.callStateRinging);
  }

  void rejectIncomingCall(String callId) {
    if (callStatusDataStore.incomingCalls?.callId == callId) {
      for (final element in callStatusDataStore.incomingCalls!.remotePeers) {
        singleCallWebRTCBuilder.reject(callId, element.remotePeer);
      }
      callStatusDataStore.incomingCalls = null;
    }
  }

  List<CallRTCSession> getRemoteStreams() {
    return callStatusDataStore.currentCall!.sessions;
  }

  MediaStream? getLocalStream() {
    return _localStream;
  }

  void onCameraStateChanged(String callId, data, RemotePeer remotePeer) {
    final cameraState = data["cameraStateChanged"] as Map<String, dynamic>;
    if (callId == callStatusDataStore.currentCall?.callId) {
      final isVideMode = cameraState["cameraStateChanged"] as bool;
      callStatusDataStore.currentCall?.sessions.forEach((element) {
        if (element.remotePeer.remoteCoreId == remotePeer.remoteCoreId) {
          element.setCameraState(!isVideMode);
        }
      });
    }
  }
}
