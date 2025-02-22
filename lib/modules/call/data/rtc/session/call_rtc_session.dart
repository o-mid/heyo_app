import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:heyo/app/modules/web-rtc/web_rtc_call_connection_manager.dart';
import 'package:heyo/modules/call/data/rtc/models.dart';

class CallRTCSession {
  CallRTCSession({
    required this.callId,
    required this.remotePeer,
    required this.isAudioCall,
    required this.onIceCandidate,
  });

  bool isAudioCall;

  void setCameraState(bool isAudio) {
    isAudioCall = isAudio;
    onCameraStateChanged?.call();
  }

  CallId callId;
  RemotePeer remotePeer;
  Function(MediaStream mediaStream)? onAddRemoteStream;
  Function(MediaStream stream)? onRemoveRemoteStream;
  Function()? onCameraStateChanged;
  MediaStream? _stream;
  Function(RTCIceCandidate candidate, CallRTCSession callRTCSession)?
      onIceCandidate;
  Function()? connected;
  Function()? accepted;

  bool isConnected = false;

  MediaStream? getStream() {
    return _stream;
  }

  RTCPeerConnection? _pc;

  set pc(RTCPeerConnection? value) {
    _pc = value;
    init();
  }

  RTCPeerConnection? get pc => _pc;

  final List<RTCIceCandidate> remoteCandidates = [];

  Future<void> init() async {
    pc!.onTrack = (event) {
      if (event.track.kind == 'video') {
        _stream = event.streams[0];
        onAddRemoteStream?.call(_stream!);
        print("bbbbbbbb CallRTCSession OnAddRemoteStream ${onAddRemoteStream}");
      }
    };
    pc!.onIceConnectionState = (RTCIceConnectionState state) {
      print("CallRTCSession On ICE connection state changed => ${state}");
      isConnected =
          (state == RTCIceConnectionState.RTCIceConnectionStateConnected);
      if (isConnected) {
        connected?.call();
      }
      if (state == RTCIceConnectionState.RTCIceConnectionStateFailed) {
        print("CallRTCSession: Failed Ice");
        //onConnectionFailed.call(callId, remotePeer.remoteCoreId);
        pc!.restartIce();
      }
    };
    pc!.onConnectionState = (state) {
      print(
          "CallRTCSession onConnectionState for ${remotePeer.remoteCoreId} is: $state");
    };
    pc!.onSignalingState = (RTCSignalingState state) {
      print("CallRTCSession state for ${remotePeer.remoteCoreId} : $state");
      if (isConnectionStable()) {
        _setPeerCandidates();
      }
    };
    pc!.onIceCandidate = (candidate) {
      onIceCandidate?.call(candidate, this);
    };
    pc!.onRemoveStream = (stream) {
      print("CallRTCSession PC : onRemoveStream");
      onRemoveRemoteStream?.call(stream);
    };
  }

  bool isConnectionStable() =>
      (pc?.signalingState == RTCSignalingState.RTCSignalingStateStable);

  Future<void> _setPeerCandidates() async {
    if (remoteCandidates.isNotEmpty) {
      List<RTCIceCandidate> candidates = List.unmodifiable(remoteCandidates);
      for (var candidate in candidates) {
        await pc!.addCandidate(candidate);
      }
      remoteCandidates.clear();
    }
  }

  Future<void> dispose() async {
    onAddRemoteStream = null;
    onRemoveRemoteStream = null;
    onCameraStateChanged = null;
    _stream = null;
    onIceCandidate = null;
    connected = null;
    accepted = null;
    await _pc!.dispose();
    await _pc!.close();
    _pc = null;
  }

  Future<RTCSessionDescription> onOfferReceived(
    String? sdp,
    String? type,
  ) async {
    accepted?.call();
    await pc!.setRemoteDescription(
      RTCSessionDescription(
        sdp,
        type,
      ),
    );
    final localDescription = await pc!.createAnswer();
    await pc!.setLocalDescription(localDescription);
    return localDescription;
  }

  Future<void> onAnswerReceived(String? sdp, String? type) async {
    await pc!.setRemoteDescription(
      RTCSessionDescription(
        sdp,
        type,
      ),
    );
  }

  static Future<CallRTCSession> createCallRTCSession(
    RemotePeer remotePeer,
    MediaStream localStream,
    bool isAudioCall,
    CallId callId,
    Function(RTCIceCandidate candidate, CallRTCSession callRTCSession)?
        onIceCandidate,
  ) async {
    final rtcSession = CallRTCSession(
      callId: callId,
      remotePeer: remotePeer,
      isAudioCall: isAudioCall,
      onIceCandidate: onIceCandidate,
    )..pc = await WebRTCCallConnectionManager.createRTCPeerConnection();

    localStream.getTracks().forEach((track) async {
      await rtcSession.pc!.addTrack(track, localStream);
    });

    return rtcSession;
  }
}
