import 'dart:convert';

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:heyo/app/modules/p2p_node/login.dart';
import 'package:sdp_transform/sdp_transform.dart';

class WebRTCConnection {
  final _videoRenderer = RTCVideoRenderer();
  late RTCPeerConnection _peerConnection;
  MediaStream? _localStream;
  Login login;

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
        await navigator.mediaDevices.getUserMedia(mediaConstraints);

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
      if (e.candidate != null) {
        print(json.encode({
          'candidate': e.candidate.toString(),
          'sdpMid': e.sdpMid.toString(),
          'sdpMlineIndex': e.sdpMLineIndex,
        }));
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

  Future<String> createOffer() async {
    RTCSessionDescription description =
        await _peerConnection.createOffer({'offerToReceiveVideo': 1});
    var session = description.sdp.toString();
    _peerConnection.setLocalDescription(description);
    return session;
  }


  Future<String> _createAnswer() async {
    RTCSessionDescription description =
        await _peerConnection.createAnswer({'offerToReceiveVideo': 1});
    var session = parse(description.sdp!);

    _peerConnection.setLocalDescription(description);
    return json.encode(session);
  }

  Future<Map<String, String>> getAcceptedOfferAnswerResult() async {
    String candidate = "";
    String session = await _createAnswer();

    _peerConnection.onIceCandidate = (e) {
      if (e.candidate != null) {
        candidate = jsonEncode({
          'candidate': e.candidate.toString(),
          'sdpMid': e.sdpMid.toString(),
          'sdpMlineIndex': e.sdpMLineIndex
        });
      }
    };
    while (candidate.isEmpty) {}
    return {'sdpAnswer':session,'candidate':candidate};
  }

  void setRemoteDescriptionWithOfferResult(String sessionText) async {
    dynamic session = await jsonDecode('$sessionText');
    String sdp = write(session, null);
    RTCSessionDescription description = RTCSessionDescription(sdp, 'offer');
    print(description.toMap());
    await _peerConnection.setRemoteDescription(description);
  }

  void setRemoteDescriptionWithAnswerResult(String sessionText) async {
    dynamic session = await jsonDecode('$sessionText');
    String sdp = write(session, null);
    RTCSessionDescription description = RTCSessionDescription(sdp, 'answer');
    print(description.toMap());
    await _peerConnection.setRemoteDescription(description);
  }
  void setCandidate(String candidateText)async{

    dynamic session= await jsonDecode('$candidateText');
    print(session['candidate']);
    dynamic candidate=new RTCIceCandidate(session['candidate'], session['sdpMid'], session['sdpMLineIndex']);
    await _peerConnection.addCandidate(candidate);
  }
}
