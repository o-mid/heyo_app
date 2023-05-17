import 'package:flutter_webrtc/flutter_webrtc.dart';

class RemotePeer {
  String remoteCoreId;
  String? remotePeerId;

  RemotePeer({required this.remoteCoreId, required this.remotePeerId});
}

class RTCSession {
  RTCSession({
    required this.remotePeer,
    required this.onRenegotiationNeeded
  });

  RemotePeer remotePeer;
  MediaStream? stream;
  RTCPeerConnection? _pc;
  Function() onRenegotiationNeeded;

  set pc(RTCPeerConnection? value) {
    _pc = value;
    init();
  }

  RTCPeerConnection? get pc => _pc;

  RTCDataChannel? dc;
  final bool isAudioCall = false;
  final List<RTCIceCandidate> remoteCandidates = [];

  void init() {
    pc!.onSignalingState = (RTCSignalingState state) {
      if (isConnectionStable()) {
        _setPeerCandidates();
      }
    };
    pc!.onRenegotiationNeeded=(){
      onRenegotiationNeeded();
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
}
