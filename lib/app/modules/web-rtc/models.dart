import 'package:flutter_webrtc/flutter_webrtc.dart';

class CallSignalingCommands {
  static const candidate = 'candidate';
  static const offer = 'offer';
  static const answer = 'answer';
  static const request = 'request';
  static const reject = 'reject';
  static const cameraOpen = 'cameraOpen';
  static const cameraClosed = 'cameraClosed';
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
  CallRTCSession(
      {required this.callId,
      required this.remotePeer,
      required this.onConnectionFailed,
      required this.isAudioCall});

  final bool isAudioCall;

  late int timeStamp;
  Function(CallId, String) onConnectionFailed;

  CallId callId;
  RemotePeer remotePeer;
  Function(MediaStream mediaStream)? onAddRemoteStream;

  MediaStream? stream;

  set(MediaStream mediaStream) {
    stream = mediaStream;
    onAddRemoteStream?.call(stream!);
  }

  RTCPeerConnection? _pc;
  bool isDataChannelConnectionAvailable = false;
  Function(RTCDataChannelMessage)? onDataChannelMessage;
  Function(RTCDataChannel)? onDataChannel;

  set pc(RTCPeerConnection? value) {
    _pc = value;
    init();
  }

  RTCPeerConnection? get pc => _pc;

  RTCDataChannel? dc;
  final List<RTCIceCandidate> remoteCandidates = [];

  //Function(RTCSessionStatus)? onNewRTCSessionStatus;
  //Function(RTCSession)? onRTCSessionConnected;

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
      _addDataChannel(channel);
    };
  }

  void _applyConnectionStateChanged(RTCPeerConnectionState state) {
    if (state == RTCPeerConnectionState.RTCPeerConnectionStateConnected) {
      /* rtcSessionStatus = RTCSessionStatus.connected;
      onRTCSessionConnected?.call(this);*/
    } else if (state ==
        RTCPeerConnectionState.RTCPeerConnectionStateConnecting) {
      //  rtcSessionStatus = RTCSessionStatus.connecting;
    } else if (state == RTCPeerConnectionState.RTCPeerConnectionStateFailed) {
      // rtcSessionStatus = RTCSessionStatus.failed;
      // onConnectionFailed.call(connectionId, remotePeer.remoteCoreId);
    } else if (state ==
        RTCPeerConnectionState.RTCPeerConnectionStateDisconnected) {
      // rtcSessionStatus = RTCSessionStatus.failed;
      //  onConnectionFailed.call(connectionId, remotePeer.remoteCoreId);
    }

    /* print(
        "onConnectionState for_applyConnectionStateChanged $state : $rtcSessionStatus $connectionId");

    isDataChannelConnectionAvailable =
    (state == RTCPeerConnectionState.RTCPeerConnectionStateConnected);

    onNewRTCSessionStatus?.call(rtcSessionStatus);*/
  }

  void _addDataChannel(RTCDataChannel channel) {
    channel.onDataChannelState = (state) {};
    channel.onDataChannelState = (e) {};
    channel.onMessage = (RTCDataChannelMessage data) {
      onDataChannelMessage?.call(data);
    };
    dc = channel;
    onDataChannel?.call(dc!);
  }

  Future<void> createDataChannel({label = 'fileTransfer'}) async {
    RTCDataChannelInit dataChannelDict = RTCDataChannelInit()
      ..maxRetransmits = 30;
    RTCDataChannel channel =
        await pc!.createDataChannel(label, dataChannelDict);
    dc = channel;
    _addDataChannel(channel);
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

   dispose() async {
    // onNewRTCSessionStatus = null;
    dc = null;
    await _pc?.dispose();
  }
}
