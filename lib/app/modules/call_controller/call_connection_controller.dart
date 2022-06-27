import 'dart:convert';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/call_controller/call_state.dart';
import 'package:heyo/app/modules/p2p_node/login.dart';
import 'package:heyo/app/modules/p2p_node/p2p_state.dart';
import 'package:heyo/app/modules/web-rtc/web-rtc-connection.dart';

class CallConnectionController extends GetxController {
  WebRTCConnection webRTCConnection;
  Login login;
  P2PState p2pState;
  String remoteCoreId = "";
  String remotePeerId = "";
  RxBool callConnectionFailed = false.obs;

  @override
  void onInit() async {
    webRTCConnection.candidate.listen((candidate) {
      if ((p2pState.callState.value is CallAccepted) ||
          (p2pState.callState.value is InCall)) {
        login.sendSDP(
            _createSDPData(null, candidate, p2pState.currentCallId.value),
            remoteCoreId,
            remotePeerId);
      }
    });
    webRTCConnection.connectionFailed.listen((ended) {
      if (ended) {
        callConnectionFailed.value = true;
      }
    });
    p2pState.candidate.listen((addCandidate) {
      if ((p2pState.callState.value is CallAccepted) ||
          (p2pState.callState.value is InCall)) {
        webRTCConnection.setCandidate(addCandidate);
      }
    });
  }

  CallConnectionController(
      {required this.webRTCConnection,
      required this.login,
      required this.p2pState});

  Future startCall(String remoteId, String callId) async {
    await webRTCConnection.initiate();

    String offer = await webRTCConnection.createSDP(true);
    remoteCoreId = remoteId;
    p2pState.recordedCallIds.add(callId);
    p2pState.currentCallId.value = callId;
    return login.sendSDP(_createSDPData(offer, null, callId), remoteId, null);
  }

  String _createSDPData(String? sdp, String? candidate, String callId) {
    var data = {'sdp': sdp, 'candidate': candidate, 'call_id': callId};
    return jsonEncode(data);
  }

  Future acceptCall(
      String sdp, String remotePeerId, String remoteCoreId) async {
    await webRTCConnection.initiate();

    this.remoteCoreId = remoteCoreId;
    this.remotePeerId = remotePeerId;
    await webRTCConnection.setRemoteDescription(sdp, false);

    final answer = await webRTCConnection.createSDP(false);
    return await login.sendSDP(
        _createSDPData(answer, null, p2pState.currentCallId.value),
        remoteCoreId,
        remotePeerId);
  }

  Future endCall() async {
    if (p2pState.callState.value is Calling) {
      return login.sendSDP(
          _createSDPData(null, null, p2pState.currentCallId.value),
          remoteCoreId,
          remotePeerId);
    }
    _reset();
  }

  callAccepted(
      String sessionText, String remoteCoreId, String remotePeerId) async {
    this.remoteCoreId = remoteCoreId;
    this.remotePeerId = remotePeerId;
    await webRTCConnection.setRemoteDescription(sessionText, true);
  }

  RTCVideoRenderer getRemoteVideRenderer() {
    return webRTCConnection.remoteVideoRenderer;
  }

  RTCVideoRenderer getLocalVideRenderer() {
    return webRTCConnection.localVideoRender;
  }

  void _reset() {
    webRTCConnection.closeStream();
    p2pState.reset();
    callConnectionFailed.value = false;
  }

  void switchCamera() {
    webRTCConnection.switchCamera();
  }

  void muteMic() {
    webRTCConnection.muteMic();
  }

  void rejectCall(String remotePeerId, String remoteCoreId) {
    p2pState.callState.value = CallState.none();
    login.sendSDP(_createSDPData(null, null, p2pState.currentCallId.value),
        remoteCoreId, remotePeerId);
  }
}
