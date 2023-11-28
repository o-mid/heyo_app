import 'package:flutter_webrtc/flutter_webrtc.dart';

class WebRTCCallConnectionManager {
  String sdpSemantics = 'unified-plan';

  static const Map<String, dynamic> iceServers = {
    'iceServers': [
      {'url': 'stun:stun.l.google.com:19302'},
      {
        "url": 'turn:turn-ca.ting.tube',
        "username": 'turn-server-ca',
        "credential": 'OIUACOasiCBSucoiasu878',
      },
      {
        "url": 'turn:turn-sg.ting.tube',
        "username": 'turn-server-sg',
        "credential": 'KIuybckIUASvycv78aSC',
      },
      {
        "url": 'turn:turn-gr.ting.tube',
        "username": 'turn-server-gr',
        "credential": 'AUISBCoa8&VSC*ASBUIc',
      },
      {
        "url": 'turn:turn-ir.ting.tube',
        "username": 'turn-server-ir',
        "credential": 'turn-server-ir',
      }
    ]
  };

  static const Map<String, dynamic> config = {
    'mandatory': {},
    'optional': [
      {'DtlsSrtpKeyAgreement': true},
    ]
  };

  static const Map<String, dynamic> dcConstraints = {
    'mandatory': {
      'OfferToReceiveAudio': false,
      'OfferToReceiveVideo': false,
    },
    'optional': [],
  };

  WebRTCCallConnectionManager();

  void setListeners(
    MediaStream? localStream,
    RTCPeerConnection pc, {
    Function(RTCDataChannel dataChannel)? onAddDataChannel,
    Function(MediaStream mediaStream)? onAddRemoteStream,
    Function(RTCPeerConnectionState connectionState)?
        onConnectionStateChangeStage,
    Function(RTCIceCandidate candidate)? onIceCandidate,
    Function(MediaStream mediaStream)? onRemoveStream,
  }) {
    pc.onTrack = (event) {
      print(
          "DEBUG race : On track stream: ${event.streams.length} :${event.streams[0].id} : track id : ${event.track.id} : ${event.track.kind}");
      if (event.track.kind == 'video') {
        onAddRemoteStream?.call(event.streams[0]);
      }
      event.track.onUnMute = () {
        print(
            "DEBUG race : On UnMuted ${event.track.kind} --- ${event.track.id}");
      };
      event.track.onMute = () {
        print("DEBUG race : Muted ${event.track.kind} --- ${event.track.id}");
      };
    };
    localStream!.getTracks().forEach((track) {
      print(
          "DEBUG race : Add track to localStream $track : ${track.id} : ${track.kind}");
      pc.addTrack(track, localStream);
    });
    pc.onDataChannel = (channel) {
      onAddDataChannel?.call(channel);
    };
    pc.onConnectionState = (state) => onConnectionStateChangeStage?.call(state);
    pc.onIceGatheringState = (RTCIceGatheringState state) {
      print("On ICE gathering state changed => ${state}");
    };
    pc.onIceConnectionState = (RTCIceConnectionState state) {
      print("On ICE connection state changed => ${state}");
    };

    pc.onRenegotiationNeeded = () {
      print("renogottionnnn neeeded");
    };
    pc.onIceCandidate = (candidate) {

      onIceCandidate?.call(candidate);
    };
    pc.onIceGatheringState = (RTCIceGatheringState state) {
      print("On ICE gathering state changed => ${state}");
    };
    pc.onRemoveStream = (stream) {
      onRemoveStream?.call(stream);
    };
  }

  Future<RTCSessionDescription> setupUpOffer(
      RTCPeerConnection pc, String media) async {
    RTCSessionDescription sessionDescription =
        await pc.createOffer(media == 'data' ? dcConstraints : {});
    await pc.setLocalDescription(sessionDescription);
    return sessionDescription;
  }

  Future<RTCSessionDescription> setupAnswer(
      RTCPeerConnection pc, String media) async {
    RTCSessionDescription sessionDescription =
        await pc.createAnswer(media == 'data' ? dcConstraints : {});
    await pc.setLocalDescription(sessionDescription);
    return sessionDescription;
  }

  Future<RTCPeerConnection> createRTCPeerConnection() async {
    RTCPeerConnection pc = await createPeerConnection({
      ...iceServers,
      ...{'sdpSemantics': sdpSemantics}
    }, config);
    return pc;
  }


  Future<MediaStream> createStream(String media, bool userScreen) async {
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
      }
    };

    MediaStream stream = userScreen
        ? await RTCFactoryNative.instance.navigator.mediaDevices
        .getDisplayMedia(mediaConstraints)
        : await RTCFactoryNative.instance.navigator.mediaDevices
        .getUserMedia(mediaConstraints);
    return stream;
  }

}
