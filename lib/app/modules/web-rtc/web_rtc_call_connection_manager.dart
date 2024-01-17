import 'package:flutter_webrtc/flutter_webrtc.dart';

class WebRTCCallConnectionManager {
  WebRTCCallConnectionManager();

  static String sdpSemantics = 'unified-plan';

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
        "credential": 'Sckjas86AVicubao9s8c7',
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

  static Future<RTCSessionDescription> setupUpOffer(
    RTCPeerConnection pc,
  ) async {
    final localDescription = await pc.createOffer({});
    await pc.setLocalDescription(localDescription);
    return localDescription;
  }

  static Future<RTCSessionDescription> setupAnswer(
    RTCPeerConnection pc,
  ) async {
    final localDescription = await pc.createAnswer();
    await pc.setLocalDescription(localDescription);
    return localDescription;
  }

  static Future<RTCPeerConnection> createRTCPeerConnection() async {
    final pc = await createPeerConnection(
      {
        ...iceServers,
        ...{'sdpSemantics': sdpSemantics},
      },
      config,
    );
    return pc;
  }

  static Future<MediaStream> createStream(String media, bool userScreen) async {
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
