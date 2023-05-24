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

  Function() onRenegotiationNeeded=(){};

  set pc(RTCPeerConnection? value) {
    _pc = value;
    init();
  }

  RTCPeerConnection? get pc => _pc;

  RTCDataChannel? dc;
  final bool isAudioCall = false;
  final List<RTCIceCandidate> remoteCandidates = [];

  void init() {
    pc!.onIceConnectionState = (RTCIceConnectionState state) {
      print("On ICE connection state changed => ${state}");

    };
    pc!.onConnectionState=(state){
      print("onConnectionState for ${remotePeer.remoteCoreId} is: $state");
    };
    pc!.onSignalingState = (RTCSignalingState state) {
      print("state for ${remotePeer.remoteCoreId} : $state");
      if (isConnectionStable()) {
        _setPeerCandidates();
      }
    };

    pc!.onDataChannel = (channel) {
      print("state for add data channel ${remotePeer.remoteCoreId} ");
      dc = channel;
    };


  }

  Future<void> createDataChannel(
      {label = 'fileTransfer'}) async {
    RTCDataChannelInit dataChannelDict = RTCDataChannelInit()
      ..maxRetransmits = 30;
    RTCDataChannel channel =
        await pc!.createDataChannel(label, dataChannelDict);
    dc = channel;
    dc!.onDataChannelState = (state) {
      print("state for data channel ${remotePeer.remoteCoreId} : $state");

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
