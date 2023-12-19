import 'package:flutter_webrtc/flutter_webrtc.dart';

class WebRTCCallConnectionManager {

  WebRTCCallConnectionManager();
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

  Future<RTCSessionDescription> setupUpOffer(
      RTCPeerConnection pc, String media) async {
    final sessionDescription =
        await pc.createOffer(media == 'data' ? dcConstraints : {});
    await pc.setLocalDescription(sessionDescription);
    return sessionDescription;
  }

  Future<RTCSessionDescription> setupAnswer(
      RTCPeerConnection pc, String media) async {
    final sessionDescription =
        await pc.createAnswer(media == 'data' ? dcConstraints : {});
    await pc.setLocalDescription(sessionDescription);
    return sessionDescription;
  }

  Future<RTCPeerConnection> createRTCPeerConnection() async {
    final pc = await createPeerConnection({
      ...iceServers,
      ...{'sdpSemantics': sdpSemantics}
    }, config);
    return pc;
  }


  Future<MediaStream> createStream(String media, bool userScreen) async {
    final mediaConstraints = <String, dynamic>{
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

    final stream = userScreen
        ? await RTCFactoryNative.instance.navigator.mediaDevices
        .getDisplayMedia(mediaConstraints)
        : await RTCFactoryNative.instance.navigator.mediaDevices
        .getUserMedia(mediaConstraints);
    return stream;
  }

}
