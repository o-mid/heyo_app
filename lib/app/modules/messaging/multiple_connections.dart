
import 'package:heyo/app/modules/messaging/models.dart';
import 'package:heyo/app/modules/messaging/single_webrtc_connection.dart';

class MultipleConnectionHandler {
  Map<String, RTCSession> connections = {};
  final SingleWebRTCConnection singleWebRTCConnection;
  Function(RTCSession)? onNewRTCSessionCreated;

  MultipleConnectionHandler({required this.singleWebRTCConnection});

  Future<RTCSession> getConnection(
      String remoteCoreId, String? remotePeerId) async {
    if (connections[remoteCoreId] == null) {
      RTCSession rtcSession = await _createSession(remoteCoreId, remotePeerId);
      return rtcSession;
    } else {
      RTCSession rtcSession = connections[remoteCoreId]!;
      if (rtcSession.rtcSessionStatus == RTCSessionStatus.failed) {
        rtcSession.dispose();
        await _createSession(remoteCoreId, remotePeerId);
      }
      return connections[remoteCoreId]!;
    }
  }

  void _setRemotePeerId(String remoteCoreId, String? remotePeerId) {
    (connections[remoteCoreId]!.remotePeer.remotePeerId == null &&
            remotePeerId != null)
        ? connections[remoteCoreId]!.remotePeer.remotePeerId = remotePeerId
        : {};
  }

  Future<RTCSession> _createSession(
      String remoteCoreId, String? remotePeerId) async {
    RTCSession rtcSession =
        await singleWebRTCConnection.createSession(remoteCoreId, remotePeerId);
    connections[remoteCoreId] = rtcSession;

    await rtcSession.createDataChannel();
    connections[remoteCoreId] = rtcSession;
    onNewRTCSessionCreated?.call(rtcSession);
    _setRemotePeerId(remoteCoreId, remotePeerId);
    return rtcSession;
  }

  // for preventing exception, always who has bigger coreId initiates the offer or starts the session
  Future<bool> initiateSession(RTCSession rtcSession, String selfCoreId) async {
    print(
        "initiator is ${(selfCoreId.compareTo(rtcSession.remotePeer.remoteCoreId) > 0)}");
    if (selfCoreId.compareTo(rtcSession.remotePeer.remoteCoreId) > 0) {
      return await singleWebRTCConnection.startSession(rtcSession);
    } else {
      return await singleWebRTCConnection.initiateSession(rtcSession);
    }
  }

  onRequestReceived(Map<String, dynamic> mapData, String remoteCoreId,
      String remotePeerId) async {
    var data = mapData[DATA];
    print("onMessage, type: ${mapData['type']}");

    switch (mapData['type']) {
      case initiate:
        {
          RTCSession rtcSession =
              await getConnection(remoteCoreId, remotePeerId);
          singleWebRTCConnection.startSession(rtcSession);
        }
        break;
      case offer:
        {
          RTCSession rtcSession =
              await getConnection(remoteCoreId, remotePeerId);
          var description = data[DATA_DESCRIPTION];
          singleWebRTCConnection.onOfferReceived(rtcSession, description);
        }
        break;
      case answer:
        {
          RTCSession rtcSession =
              await getConnection(remoteCoreId, remotePeerId);
          var description = data[DATA_DESCRIPTION];
          singleWebRTCConnection.onAnswerReceived(rtcSession, description);
        }
        break;
      case candidate:
        {
          RTCSession rtcSession =
              await getConnection(remoteCoreId, remotePeerId);
          var candidateMap = data[candidate];
          singleWebRTCConnection.onCandidateReceived(rtcSession, candidateMap);
        }
        break;
    }
  }
}
