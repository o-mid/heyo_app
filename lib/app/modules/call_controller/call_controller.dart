import 'dart:convert';

import 'package:flutter_p2p_communicator/flutter_p2p_communicator.dart';
import 'package:flutter_p2p_communicator/model/req_res_model.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/p2p_node/login.dart';
import 'package:heyo/app/modules/web-rtc/web-rtc-connection.dart';

class CallConnectionController extends GetxController{
  WebRTCConnection webRTCConnection;
  Login login;

  @override
  void onInit(){
    webRTCConnection.initiate();
  }
  CallConnectionController({required this.webRTCConnection, required this.login});

  Future startCall(String remoteId) async {
    String offer = await jsonEncode(await webRTCConnection.createOffer());

    return login.sendOffer(offer, remoteId);
  }

  acceptCall(String session, String eventId) async {
    webRTCConnection.setRemoteDescriptionWithOfferResult(session);

    final acceptedCallResponse = await webRTCConnection.getAcceptedOfferAnswerResult();
    FlutterP2pCommunicator.sendResponse(
        info: P2PReqResNodeModel(
            name: P2PReqResNodeNames.login,
            body: acceptedCallResponse,
            id: eventId));
  }

  callAccepted(String sessionText, String candidate) async {
    webRTCConnection.setRemoteDescriptionWithOfferResult(sessionText);
    webRTCConnection.setCandidate(candidate);
  }
}
