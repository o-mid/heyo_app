import 'package:flutter_webrtc/flutter_webrtc.dart';

class RemotePeer {
  String remoteCoreId;
  String? remotePeerId;

  RemotePeer({required this.remoteCoreId, required this.remotePeerId});
}

ConnectionId generateConnectionId() {
  return '${DateTime.now().millisecondsSinceEpoch}';
}

typedef ConnectionId = String;

extension RTCInfo on ConnectionId {
  int getTimeStamp() {
    return int.parse(this);
  }
}

enum RTCSessionStatus { none, connecting, failed, connected }

class RTCSession {
  RTCSession(
      {required this.connectionId,
      required this.remotePeer,
      required this.onConnectionFailed}) {
    timeStamp = connectionId.getTimeStamp();
  }

  late int timeStamp;
  Function(ConnectionId, String) onConnectionFailed;

  ConnectionId connectionId;
  late RemotePeer remotePeer;
  MediaStream? stream;
  RTCPeerConnection? _pc;
  bool isDataChannelConnectionAvailable = false;

  set pc(RTCPeerConnection? value) {
    _pc = value;
    init();
  }

  RTCPeerConnection? get pc => _pc;

  RTCDataChannel? dc;
  final bool isAudioCall = false;
  final List<RTCIceCandidate> remoteCandidates = [];
  RTCSessionStatus rtcSessionStatus = RTCSessionStatus.none;
  Function(RTCSessionStatus)? onNewRTCSessionStatus;

  void init() {
    pc!.onIceConnectionState = (RTCIceConnectionState state) {
      print("On ICE connection state changed => ${state}");
      if (state == RTCIceConnectionState.RTCIceConnectionStateDisconnected) {
        rtcSessionStatus = RTCSessionStatus.failed;
        onConnectionFailed.call(connectionId, remotePeer.remoteCoreId);
        onNewRTCSessionStatus?.call(rtcSessionStatus);
      }
    };
    pc!.onConnectionState = (state) {
      _applyConnectionStateChanged(state);
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

  void _applyConnectionStateChanged(RTCPeerConnectionState state) {
    if (state == RTCPeerConnectionState.RTCPeerConnectionStateConnected) {
      rtcSessionStatus = RTCSessionStatus.connected;
    } else if (state ==
        RTCPeerConnectionState.RTCPeerConnectionStateConnecting) {
      rtcSessionStatus = RTCSessionStatus.connecting;
    } else if (state == RTCPeerConnectionState.RTCPeerConnectionStateFailed) {
      rtcSessionStatus = RTCSessionStatus.failed;
      onConnectionFailed.call(connectionId, remotePeer.remoteCoreId);
    } else if (state ==
        RTCPeerConnectionState.RTCPeerConnectionStateDisconnected) {
      rtcSessionStatus = RTCSessionStatus.failed;
      onConnectionFailed.call(connectionId, remotePeer.remoteCoreId);
    }

    print(
        "onConnectionState for_applyConnectionStateChanged $state : $rtcSessionStatus");

    isDataChannelConnectionAvailable =
        (state == RTCPeerConnectionState.RTCPeerConnectionStateConnected);

    onNewRTCSessionStatus?.call(rtcSessionStatus);
  }

  Future<void> createDataChannel({label = 'fileTransfer'}) async {
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

  void dispose() {
    onNewRTCSessionStatus = null;
    dc = null;
  }
}
