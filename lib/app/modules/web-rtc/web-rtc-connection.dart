import 'dart:convert';

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:sdp_transform/sdp_transform.dart';

class WebRTCConnection {
  RTCVideoRenderer remoteVideoRenderer = RTCVideoRenderer();
  RTCVideoRenderer localVideoRender = RTCVideoRenderer();

  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  final candidate = "".obs;
  final RxBool connectionFailed = false.obs;

  initiate() async {
    await remoteVideoRenderer.initialize();
    await localVideoRender.initialize();
    await _createPeerConnecion().then((pc) {
      _peerConnection = pc;
    });

    _peerConnection!.onConnectionState = (state) {
      if (state == RTCPeerConnectionState.RTCPeerConnectionStateDisconnected) {
        connectionFailed.value = true;
      }
    };
  }

  _getUserMedia() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video': {
        'facingMode': 'user',
      }
    };

    MediaStream stream = await RTCFactoryNative.instance.navigator.mediaDevices
        .getUserMedia(mediaConstraints);

    localVideoRender.srcObject = stream;
    return stream;
  }

  _createPeerConnecion() async {
    Map<String, dynamic> configuration = {
      "iceServers": [
        {"url": "stun:stun.l.google.com:19302"},
        {
          "url": 'turn:77.73.67.64:3478',
          "username": 'turn-demo-server',
          "credential": 'coiansliocuna89s7ca',
          "credentialType": 'password',
        }
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

        candidate.value = json.encode({
          'candidate': e.candidate.toString(),
          'sdpMid': e.sdpMid.toString(),
          'sdpMlineIndex': e.sdpMLineIndex,
        });
      }
    };

    pc.onIceConnectionState = (e) {
      print(e);
    };

    pc.onAddStream = (stream) {
      print('addStream: ' + stream.id);
      remoteVideoRenderer.srcObject = stream;
    };

    return pc;
  }

  void switchCamera() {
    _localStream?.getVideoTracks()[0].switchCamera();
  }

  void muteMic() {
    if (_localStream != null) {
      bool enabled = _localStream!.getAudioTracks()[0].enabled;
      _localStream!.getAudioTracks()[0].enabled = !enabled;
    }
  }

  Future<String> createSDP(bool isOffer) async {
    final RTCSessionDescription description;
    if (isOffer) {
      description =
          await _peerConnection!.createOffer({'offerToReceiveVideo': 1});
    } else {
      description =
          await _peerConnection!.createAnswer({'offerToReceiveVideo': 1});
    }
    var session = description.sdp.toString();
    _peerConnection!.setLocalDescription(description);
    return json.encode(parse(session));
  }

  Future setRemoteDescription(String sessionText, bool isOffer) async {
    dynamic session = await jsonDecode('$sessionText');
    String sdp = write(session, null);
    RTCSessionDescription description =
        RTCSessionDescription(sdp, isOffer ? 'answer' : 'offer');
    print(description.toMap());
    await _peerConnection!.setRemoteDescription(description);
  }

  Future setCandidate(String candidateText) async {
    dynamic session = await jsonDecode('$candidateText');
    dynamic candidate = RTCIceCandidate(
        session['candidate'], session['sdpMid'], session['sdpMlineIndex']);
    await _peerConnection!.addCandidate(candidate);
  }

  void closeStream() {
    remoteVideoRenderer.dispose();
    localVideoRender.dispose();
    _localStream?.dispose();
    _localStream = null;
    remoteVideoRenderer = RTCVideoRenderer();
    localVideoRender = RTCVideoRenderer();
    _peerConnection?.close();
    _peerConnection = null;
    connectionFailed.value = false;
  }
}
