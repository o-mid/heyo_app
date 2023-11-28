
import 'package:flutter_webrtc/flutter_webrtc.dart';

class WebRTCConnectionManager{
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

  WebRTCConnectionManager();



  void setListeners(
    //  MediaStream? localStream,
      RTCPeerConnection pc, {
       // Function(RTCDataChannel dataChannel)? onAddDataChannel,
     //   Function(MediaStream mediaStream)? onAddRemoteStream,
      //  Function(RTCPeerConnectionState connectionState)?,
        //onConnectionStateChangeStage,
        Function(RTCIceCandidate candidate)? onIceCandidate,
      }) {

    pc.onRenegotiationNeeded=(){
      print("renogottionnnn neeeded");
    };
    pc.onIceCandidate = (candidate) {
      if(candidate==null){
        return;
      }
      onIceCandidate?.call(candidate);
    };
     pc.onIceGatheringState = (RTCIceGatheringState state) {
      print("On ICE gathering state changed => ${state}");
    };

  }

  Future<RTCSessionDescription> setupUpOffer(
      RTCPeerConnection pc ,String media) async {
    RTCSessionDescription sessionDescription =
    await pc.createOffer(media == 'data' ?  dcConstraints : {});
    await pc.setLocalDescription(sessionDescription);
    return sessionDescription;
  }

  Future<RTCSessionDescription> setupAnswer(
      RTCPeerConnection pc ,String media) async {
    RTCSessionDescription sessionDescription =
    await pc.createAnswer(media == 'data' ?  dcConstraints : {});
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
}