import 'package:get/get.dart';
import 'package:heyo/app/modules/p2p_node/login.dart';
import 'package:heyo/app/modules/web-rtc/web-rtc-connection.dart';

class CallConnectionController extends GetxController {
  WebRTCConnection webRTCConnection;
  Login login;

  @override
  void onInit() {
    webRTCConnection.initiate();
  }

  CallConnectionController(
      {required this.webRTCConnection, required this.login});

  Future startCall(String remoteId) async {
    String offer = await webRTCConnection.createSDP(true);
    return login.sendSDP(offer, remoteId, null);
  }

  Future acceptCall(String session, String eventId, String remotePeerId,
      String remoteCoreId) async {
    print("sebdiubg acceptt");
    //await webRTCConnection.setRemoteDescriptionWithOfferResult(session);
    await webRTCConnection.setRemoteDescription(session);

    final answer = await webRTCConnection.createSDP(false);
    print("sebdiubg acceptt121");
    return await login.sendSDP(answer, remoteCoreId, remotePeerId);
  }

  callAccepted(String sessionText) async {
    //await  webRTCConnection.setRemoteDescriptionWithAnswerResult(sessionText);
    await webRTCConnection.setRemoteDescription(sessionText);

    // webRTCConnection.setCandidate(candidate);
  }
}
