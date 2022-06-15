import 'dart:convert';

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:heyo/app/modules/p2p_node/login.dart';
import 'package:sdp_transform/sdp_transform.dart';

class WebRTCConnection {
  final _videoRenderer = RTCVideoRenderer();
  late RTCPeerConnection _peerConnection;
  MediaStream? _localStream;
  Login login;
  String candidate = "";

  WebRTCConnection({required this.login});

  initiate() {
    _videoRenderer.initialize();

    _createPeerConnecion().then((pc) {
      _peerConnection = pc;
    });
  }

  _getUserMedia() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video': {
        'facingMode': 'user',
      }
    };

    MediaStream stream =
        await  RTCFactoryNative.instance.navigator.mediaDevices.getUserMedia(mediaConstraints);

    _videoRenderer.srcObject = stream;
    return stream;
  }

  _createPeerConnecion() async {
    Map<String, dynamic> configuration = {
      "iceServers": [
        {"url": "stun:stun.l.google.com:19302"},
      ]
    };

    final Map<String, dynamic> offerSdpConstraints = {
      "mandatory": {
        "OfferToReceiveAudio": true,
        "OfferToReceiveVideo": true,
      },
      "optional": [],
    };

    _localStream = await _getUserMedia();

    RTCPeerConnection pc =
        await createPeerConnection(configuration, offerSdpConstraints);

    pc.addStream(_localStream!);

    pc.onIceCandidate = (e) {
      print("candidate= ${(e.candidate != null)}");

      if (e.candidate != null) {
        print("candidate= ${(e.candidate)}");

        candidate = json.encode({
          'candidate': e.candidate.toString(),
          'sdpMid': e.sdpMid.toString(),
          'sdpMlineIndex': e.sdpMLineIndex,
        });
      }
    };

    pc.onIceConnectionState = (e) {
      print(e);
    };

    /*pc.onAddStream = (stream) {
      print('addStream: ' + stream.id);
      _remoteVideoRenderer.srcObject = stream;
    };*/

    return pc;
  }

  Future<String> createSDP(bool isOffer) async {
    final RTCSessionDescription description;
    if (isOffer) {
      _offer = true;
      description =
          await _peerConnection.createOffer({'offerToReceiveVideo': 1});
    } else {
      description =
          await _peerConnection.createAnswer({'offerToReceiveVideo': 1});
    }
    var session = description.sdp.toString();
    _peerConnection.setLocalDescription(description);
    return json.encode(parse(session));
  }

  /*Future<Map<String, String>> getAcceptedOfferAnswerResult() async {

    _peerConnection.onIceCandidate = (e) {
      if (e.candidate != null) {
        print("candidate: $e");
        candidate = jsonEncode({
          'candidate': e.candidate.toString(),
          'sdpMid': e.sdpMid.toString(),
          'sdpMlineIndex': e.sdpMLineIndex
        });
      }
    };
    _peerConnection.restartIce();

    String session = await _createAnswer();

    while (candidate.isEmpty) {
    }
    return {'sdpAnswer': session, 'candidate': candidate};
  }*/

  Future setRemoteDescriptionWithOfferResult(String sessionText) async {
    Map<String, dynamic> session = await jsonDecode(sessionText);
    String sdp = write(session, null);
    RTCSessionDescription description = RTCSessionDescription(sdp, 'offer');
    await _peerConnection.setRemoteDescription(description);
  }

  Future setRemoteDescriptionWithAnswerResult(String sessionText) async {
    Map<String, dynamic> session = await jsonDecode(sessionText);
    String sdp = write(session, null);
    RTCSessionDescription description = RTCSessionDescription(sdp, 'answer');
    await _peerConnection.setRemoteDescription(description);
  }

  bool _offer = false;

  Future setRemoteDescription(String sessionText) async {
    print("asfdfda ${_offer}");

    print("asfdfda ${_offer ? 'answer' : 'offer'}");
    dynamic session = await jsonDecode('$sessionText');
    String sdp = write(session, null);
    RTCSessionDescription description =
        RTCSessionDescription(sdp, _offer ? 'answer' : 'offer');
    print(description.toMap());
    await _peerConnection.setRemoteDescription(description);
  }

  Future setCandidate(String candidateText) async {
    dynamic session = await jsonDecode('$candidateText');
    print(session['candidate']);
    dynamic candidate = new RTCIceCandidate(
        session['candidate'], session['sdpMid'], session['sdpMLineIndex']);
    await _peerConnection.addCandidate(candidate);
  }
}
