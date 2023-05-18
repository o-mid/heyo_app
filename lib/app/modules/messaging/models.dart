import 'package:flutter_webrtc/flutter_webrtc.dart';

class RemotePeer {
  String remoteCoreId;
  String? remotePeerId;

  RemotePeer({required this.remoteCoreId, required this.remotePeerId});
}

class RTCSession {
  RTCSession({required this.remotePeer});

  RemotePeer remotePeer;
  MediaStream? stream;
  RTCPeerConnection? _pc;
  bool isDataChannelConnectionAvailable = false;

  //Function() onRenegotiationNeeded;

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
    pc!.onRenegotiationNeeded = () {
      // onRenegotiationNeeded();
    };
    pc!.onSignalingState = (state) {
      print("state for ${remotePeer.remoteCoreId} : $state");
    };
    pc!.onDataChannel = (channel) {
      dc = channel;
    };
    dc?.onDataChannelState = (state) {
      isDataChannelConnectionAvailable =
          (state == RTCDataChannelState.RTCDataChannelOpen);
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
