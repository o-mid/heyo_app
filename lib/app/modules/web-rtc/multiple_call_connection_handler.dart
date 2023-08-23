import 'package:heyo/app/modules/web-rtc/single_call_web_rtc_connection.dart';
import 'package:heyo/app/modules/web-rtc/models.dart';

class CallConnectionsHandler {
  SingleCallWebRTCBuilder singleCallWebRTCBuilder;

  CallConnectionsHandler({required this.singleCallWebRTCBuilder});

  late CallId _callId;
  List<CallRTCSession> sessions = [];

  requestCall(String remoteCoreId) async {
    _callId = generateCallId();
    CallRTCSession callRTCSession = await _createSession(_callId,remoteCoreId,null);
    singleCallWebRTCBuilder.requestSession(callRTCSession);
    //generate a connectionId
    //send requestCall
  }

  Future<CallRTCSession> _createSession(CallId callId,String remoteCoreId,String? remotePeerId) async {
    CallRTCSession callRTCSession = await singleCallWebRTCBuilder.createSession(
        _callId, remoteCoreId, null);
    sessions.add(callRTCSession);
    return callRTCSession;
  }

  Future<CallRTCSession> _getConnection(
      String remoteCoreId, String remotePeerId, CallId callId) async{
    for (var value in sessions) {
      if (value.remotePeer.remoteCoreId == remoteCoreId) {
        return value;
      }
    }
    return _createSession(callId, remoteCoreId, remotePeerId);
  }

  addParticipants(String remoteCoreId) {
    //get current participants
    //sendCall request with an array of participants
  }

  onMessage() {
    //if gets a call request for this array
    //notifies others and waits for accept
  }

  accept(List<String> remotes, String callerId) {
    //send offer to remotes with this callId
  }

  reject(String callerId) {}

  close() {
    //remove connectionId
  }

  Future<void> onRequestReceived(Map<String, dynamic> mapData,
      String remoteCoreId, String remotePeerId) async {
    var data = mapData[DATA];
    print("onMessage, type: ${mapData['type']}");

    switch (mapData['type']) {
      case CallSignalingCommands.request:
        {
           //TODO show the user income
          //user accepts or rejects
          //accepting means
        }
        break;
      /*case initiate:
        {
          String connectionId = mapData[CONNECTION_ID];

          RTCSession rtcSession =
          await _getConnection(connectionId, remoteCoreId, remotePeerId);
          singleWebRTCConnection.startSession(rtcSession);
        }
        break;*/
      case CallSignalingCommands.offer:
        {
          String callId = mapData[CALL_ID];

          CallRTCSession rtcSession =
              await _getConnection(callId, remoteCoreId, remotePeerId);
          var description = data[DATA_DESCRIPTION];

          await singleCallWebRTCBuilder.onOfferReceived(
              rtcSession, description);
        }
        break;
      case CallSignalingCommands.answer:
        {
          String callId = mapData[CALL_ID];
          CallRTCSession rtcSession =
              await _getConnection(callId, remoteCoreId, remotePeerId);
          var description = data[DATA_DESCRIPTION];
          await singleCallWebRTCBuilder.onAnswerReceived(
              rtcSession, description);
        }
        break;
      case CallSignalingCommands.candidate:
        {
          String callId = mapData[CALL_ID];

          CallRTCSession rtcSession =
              await _getConnection(callId, remoteCoreId, remotePeerId);
          var candidateMap = data[CallSignalingCommands.candidate];
          await singleCallWebRTCBuilder.onCandidateReceived(
              rtcSession, candidateMap);
        }
        break;
    }
  }
}
