
import 'package:flutter_webrtc/flutter_webrtc.dart';

class WebRTCConnectionManager{
  String sdpSemantics = 'unified-plan';

  static const Map<String, dynamic> iceServers = {
    'iceServers': [
      {'url': 'stun:stun.l.google.com:19302'},
      {
        "url": 'turn:77.73.67.64:3478',
        "username": 'turn-demo-server',
        "credential": 'coiansliocuna89s7ca',
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
        Future Function(RTCIceCandidate candidate)? onIceCandidate,
      }) {
  /*  pc.onTrack = (event) {
      print("DEBUG race : On track stream: ${event.streams.length} :${event.streams[0].id} : track id : ${event.track.id}");
      if (event.track.kind == 'video') {
        onAddRemoteStream?.call(event.streams[0]);
      }
      event.track.onUnMute = (){
        print("DEBUG race : On UnMuted ${event.track.kind} --- ${event.track.id}");
      };
      event.track.onMute = (){
        print("DEBUG race : Muted ${event.track.kind} --- ${event.track.id}");
      };
    };*/
   /* localStream?.getTracks().forEach((track) {
      print("DEBUG race : Add track to localStream $track : ${track.id} : ${track.kind}");
      pc.addTrack(track, localStream);
    });*/

    pc.onIceCandidate = (candidate) => onIceCandidate?.call(candidate);
   /* pc.onDataChannel = (channel) {
      onAddDataChannel?.call(channel);
    };*/
 //   pc.onConnectionState = (state) => onConnectionStateChangeStage?.call(state);
    pc.onIceGatheringState = (RTCIceGatheringState state) {
      print("On ICE gathering state changed => ${state}");
    };
    pc.onIceConnectionState = (RTCIceConnectionState state) {
      print("On ICE connection state changed => ${state}");
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