import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:heyo/app/modules/calls/shared/data/models/all_participant_model/all_participant_model.dart';
import 'package:heyo/app/modules/connection/domain/connection_contractor.dart';
import 'package:heyo/app/modules/connection/domain/connection_models.dart';
import 'package:heyo/app/modules/calls/data/models.dart';
import 'package:heyo/app/modules/calls/data/rtc/single_call_web_rtc_connection.dart';

enum CallState {
  callStateNew,
  callStateRinging,
  callStateInvite,
  callStateConnected,
  callStateBye,
  callStateBusy
}

class CurrentCall {
  final CallId callId;
  final List<CallRTCSession> activeSessions;

  CurrentCall({required this.callId, required this.activeSessions});
}

class CallInfo {
  RemotePeer remotePeer;
  bool isAudioCall;

  CallInfo({required this.remotePeer, required this.isAudioCall});
}

class RequestedCalls {
  final CallId callId;
  final List<CallInfo> remotePeers;

  RequestedCalls({required this.callId, required this.remotePeers});
}

class IncomingCalls {
  final CallId callId;
  final List<CallInfo> remotePeers;

  IncomingCalls({required this.callId, required this.remotePeers});
}

class CallConnectionsHandler {
  SingleCallWebRTCBuilder singleCallWebRTCBuilder;
  MediaStream? _localStream;
  Function(MediaStream stream)? onLocalStream;
  IncomingCalls? _incomingCalls;
  Function(CallRTCSession callRTCSession)? onAddRemoteStream;

  Function(AllParticipantModel participate)? onChangeParticipateStream;
  final ConnectionContractor connectionContractor;

  CallConnectionsHandler({required this.singleCallWebRTCBuilder,required this.connectionContractor}) {
    connectionContractor.getMessageStream().listen((event) {
      if (event is CallConnectionDataReceived) {
        onRequestReceived(
          event.mapData,
          event.remoteCoreId,
          event.remotePeerId,
        );
      }
    });
  }

  Function(CallId callId, List<CallInfo> callInfo, CallState state)?
      onCallStateChange;

  CurrentCall? _currentCall;
  RequestedCalls? requestedCalls;

  Future<void> addMember(String remoteCoreId) async {
    _currentCall!.activeSessions.forEach((element) {
      singleCallWebRTCBuilder.addMemberEvent(remoteCoreId, element);
    });
    //TODO refactor isAudio
    final callRTCSession = await _createSession(
      RemotePeer(
        remoteCoreId: remoteCoreId,
        remotePeerId: null,
      ),
      _currentCall!.activeSessions.first.isAudioCall,
    );
    singleCallWebRTCBuilder.requestSession(
      callRTCSession,
      _currentCall!.activeSessions
          .map((e) => e.remotePeer.remoteCoreId)
          .toList(),
    );
  }

  Future<CallRTCSession> requestCall(
    String remoteCoreId,
    bool isAudioCall,
  ) async {
    CallId callId = generateCallId();
    _currentCall = CurrentCall(callId: callId, activeSessions: []);
    CallRTCSession callRTCSession = await _createSession(
      RemotePeer(remoteCoreId: remoteCoreId, remotePeerId: null),
      isAudioCall,
    );
    singleCallWebRTCBuilder.requestSession(callRTCSession, []);
    CallInfo callInfo = CallInfo(
      remotePeer: RemotePeer(remoteCoreId: remoteCoreId, remotePeerId: null),
      isAudioCall: isAudioCall,
    );
    onCallStateChange?.call(callId, [callInfo], CallState.callStateNew);
    onCallStateChange?.call(callId, [callInfo], CallState.callStateInvite);
    //generate a connectionId
    //send requestCall
    return callRTCSession;
  }

  Future<CallRTCSession> _createSession(
    RemotePeer remotePeer,
    bool isAudioCall,
  ) async {
    if (_localStream == null) {
      _localStream = await singleCallWebRTCBuilder.createStream('video', false);
      onLocalStream?.call(_localStream!);
    }
    CallRTCSession callRTCSession = await singleCallWebRTCBuilder.createSession(
      _currentCall!.callId,
      remotePeer,
      _localStream!,
      isAudioCall,
    );
    callRTCSession.onAddRemoteStream = (stream) {
      onAddRemoteStream?.call(callRTCSession);
    };
    _currentCall!.activeSessions.add(callRTCSession);
    return callRTCSession;
  }

  CallRTCSession? _getConnection(String remoteCoreId, CallId callId) {
    for (var value in _currentCall!.activeSessions) {
      if (value.callId == callId &&
          value.remotePeer.remoteCoreId == remoteCoreId) {
        return value;
      }
    }
    return null;
  }

  Future<void> accept(CallId callId) async {
    print("accepttt ${_incomingCalls}");
    if (_incomingCalls?.callId == callId) {
      _currentCall = CurrentCall(callId: callId, activeSessions: []);
      _incomingCalls!.remotePeers.forEach((element) async {
        print("accept ${element.remotePeer.remoteCoreId}");
        CallRTCSession callRTCSession =
            await _createSession(element.remotePeer, element.isAudioCall);
        singleCallWebRTCBuilder.startSession(callRTCSession);
      });
    }
    // singleCallWebRTCBuilder.startSession(rtcSession)
  }

  Future<void> reject(String callId) async {
    if (_currentCall?.callId == callId) {
      _currentCall?.activeSessions.forEach((element) {
        singleCallWebRTCBuilder.reject(callId, element.remotePeer);
      });
    }
  }

  Future<void> close() async {
    if (_currentCall != null) {
      for (var element in _currentCall!.activeSessions) {
        await element.dispose();
      }
      _currentCall!.activeSessions.clear();
      _currentCall = null;
    }
    _localStream?.getTracks().forEach((element) async {
      await element.stop();
    });
    _localStream?.dispose();
    _localStream = null;
  }

  Future<void> onRequestReceived(
    Map<String, dynamic> mapData,
    String remoteCoreId,
    String remotePeerId,
  ) async {
    var data = mapData[DATA];
    print("onMessage, type: ${mapData['type']}");

    switch (mapData['type']) {
      case CallSignalingCommands.request:
        {
          _onCallRequestReceived(
            mapData,
            data,
            RemotePeer(
              remoteCoreId: remoteCoreId,
              remotePeerId: remotePeerId,
            ),
          );
        }
        break;
      case CallSignalingCommands.reject:
        {
          onCallRequestRejected(
            mapData,
            RemotePeer(
              remoteCoreId: remoteCoreId,
              remotePeerId: remotePeerId,
            ),
          );
        }
        break;
      case CallSignalingCommands.offer:
        {
          String callId = mapData[CALL_ID] as String;

          CallRTCSession rtcSession = _getConnection(remoteCoreId, callId)!;
          var description = data[DATA_DESCRIPTION];
          rtcSession.remotePeer.remotePeerId ??= remotePeerId;

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
        break;
      case CallSignalingCommands.answer:
        {
          String callId = mapData[CALL_ID] as String;
          CallRTCSession rtcSession = _getConnection(remoteCoreId, callId)!;
          rtcSession.remotePeer.remotePeerId ??= remotePeerId;
          var description = data[DATA_DESCRIPTION];
          singleCallWebRTCBuilder.onAnswerReceived(rtcSession, description);
        }
        break;
      case CallSignalingCommands.candidate:
        {
          String callId = mapData[CALL_ID] as String;

          CallRTCSession rtcSession = _getConnection(remoteCoreId, callId)!;
          rtcSession.remotePeer.remotePeerId ??= remotePeerId;

          var candidateMap = data[CallSignalingCommands.candidate];
          singleCallWebRTCBuilder.onCandidateReceived(rtcSession, candidateMap);
        }
        break;
      case CallSignalingCommands.newMember:
        {
          final callId = mapData[CALL_ID] as String;
          final member = data[CallSignalingCommands.newMember] as String;
          if (callId == _currentCall?.callId) {
            CallRTCSession callRTCSession = await _createSession(
              RemotePeer(
                remoteCoreId: member,
                remotePeerId: null,
              ),
              _currentCall!.activeSessions.first.isAudioCall,
            );
          }
        }
    }
  }

  void switchCamera() {}

  void muteMic() {
    if (_localStream != null) {
      bool enabled = _localStream!.getAudioTracks()[0].enabled;
      _localStream!.getAudioTracks()[0].enabled = !enabled;
    }
  }

  void showLocalVideoStream(bool value) {
    if (_localStream != null) {
      _localStream!.getVideoTracks()[0].enabled = value;
    }
  }

  void peerOpendCamera(String sessionId) {}

  void peerClosedCamera(String sessionId) {}

  Future<MediaStream> _createStream(String media, bool userScreen) async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video': userScreen
          ? true
          : {
              'mandatory': {
                'minWidth': '640',
                // Provide your own width, height and frame rate here
                'minHeight': '480',
                'minFrameRate': '30',
              },
              'facingMode': 'user',
              'optional': [],
            },
    };

    MediaStream stream = userScreen
        ? await RTCFactoryNative.instance.navigator.mediaDevices
            .getDisplayMedia(mediaConstraints)
        : await RTCFactoryNative.instance.navigator.mediaDevices
            .getUserMedia(mediaConstraints);
    _localStream = stream;
    onLocalStream?.call(stream);
    return stream;
  }

  Future<void> onCallRequestRejected(mapData, RemotePeer remotePeer) async {
    String callId = mapData[CALL_ID] as String;
    if (_currentCall != null) {
      CallRTCSession? callRTCSession =
          _getConnection(remotePeer.remoteCoreId, callId);
      if (callRTCSession != null) {
        //TODO update based on..
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
        await callRTCSession.dispose();
        _currentCall?.activeSessions.removeWhere(
          (element) =>
              element.remotePeer.remoteCoreId == remotePeer.remoteCoreId,
        );
      }
    }
    if (_incomingCalls != null) {
      onCallStateChange?.call(
        callId,
        [_incomingCalls!.remotePeers.first],
        CallState.callStateBye,
      );
      _incomingCalls = null;
    }
  }

  void _onCallRequestReceived(mapData, data, remotePeer) {
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
    _incomingCalls = IncomingCalls(callId: callId, remotePeers: remotePeers);

    onCallStateChange?.call(callId, [callInfo], CallState.callStateNew);

    onCallStateChange?.call(callId, [callInfo], CallState.callStateRinging);
  }

  void rejectIncomingCall(String callId) {
    if (_incomingCalls?.callId == callId) {
      _incomingCalls?.remotePeers.forEach((element) {
        print("rejectcd 2");

        singleCallWebRTCBuilder.reject(callId, element.remotePeer);
      });
      _incomingCalls = null;
    }
  }

  List<CallRTCSession> getRemoteStreams() {
    return _currentCall!.activeSessions;
  }

  MediaStream? getLocalStream() {
    return _localStream;
  }
}
