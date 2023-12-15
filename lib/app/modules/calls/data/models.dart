import 'package:flutter_webrtc/flutter_webrtc.dart';

class CallSignalingCommands {
  static const candidate = 'candidate';
  static const offer = 'offer';
  static const answer = 'answer';
  static const request = 'request';
  static const reject = 'reject';
  static const newMember = 'newMemer';
  static const cameraStateChanged = 'cameraStateChanged';
}

CallId generateCallId() {
  return '${DateTime.now().millisecondsSinceEpoch}';
}

class RemotePeer {
  String remoteCoreId;
  String? remotePeerId;

  RemotePeer({required this.remoteCoreId, required this.remotePeerId});
}

typedef CallId = String;

class CallRTCSession {
  CallRTCSession({
    required this.callId,
    required this.remotePeer,
    required this.onConnectionFailed,
    required this.isAudioCall,
  });

  final bool isAudioCall;

  Function(CallId, String) onConnectionFailed;

  CallId callId;
  RemotePeer remotePeer;
  Function(MediaStream mediaStream)? onAddRemoteStream;
  Function(MediaStream stream)? onRemoveRemoteStream;
  MediaStream? _stream;

  setRemoteStream(MediaStream mediaStream) {
    _stream = mediaStream;
    onAddRemoteStream?.call(_stream!);
  }

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

  void init() {
    pc!.onIceConnectionState = (RTCIceConnectionState state) {
      print("On ICE connection state changed => ${state}");
      /*  if (state == RTCIceConnectionState.RTCIceConnectionStateDisconnected) {
        rtcSessionStatus = RTCSessionStatus.failed;
        onConnectionFailed.call(connectionId, remotePeer.remoteCoreId);
        onNewRTCSessionStatus?.call(rtcSessionStatus);
      }*/
    };
    pc!.onConnectionState = (state) {
      print("onConnectionState for ${remotePeer.remoteCoreId} is: $state");
    };
    pc!.onSignalingState = (RTCSignalingState state) {
      print("state for ${remotePeer.remoteCoreId} : $state");
      if (isConnectionStable()) {
        _setPeerCandidates();
      }
    };
    pc!.onRemoveStream = (stream) {
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
    await _pc?.dispose();
  }
}
