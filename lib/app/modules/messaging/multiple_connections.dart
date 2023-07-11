import 'package:heyo/app/modules/messaging/models.dart';
import 'package:heyo/app/modules/messaging/single_webrtc_connection.dart';

class MultipleConnectionHandler {
  Map<ConnectionId, RTCSession> connections = {};
  final SingleWebRTCConnection singleWebRTCConnection;
  Function(RTCSession)? onNewRTCSessionCreated;

  MultipleConnectionHandler({required this.singleWebRTCConnection});

  RTCSession? getConnection(String remoteCoreId, String selfCoreId) {
    RTCSession? rtcSession;

    List<RTCSession> items = connections.values
        .where((element) => element.remotePeer.remoteCoreId == remoteCoreId)
        .toList();

    bool initiate = false;
    if (items.isEmpty) {
      initiateSession(remoteCoreId, selfCoreId);
    } else {
      for (var element in items) {
        if (element.rtcSessionStatus != RTCSessionStatus.failed) {
          rtcSession = element;
        } else {
          initiate = true;
          connections[element.connectionId]?.dispose();
          connections.remove(element.connectionId);
        }
      }
    }
    if (initiate) {
      initiateSession(remoteCoreId, selfCoreId);
    }

    return rtcSession;
  }

  Future<RTCSession> _getConnection(
    ConnectionId connectionId,
    String remoteCoreId,
    String? remotePeerId,
  ) async {
    print("_getConnection");
    if (connections[connectionId] == null) {
      RTCSession rtcSession =
          await _createSession(connectionId, remoteCoreId, remotePeerId);
      print("_getConnection new created");

      return rtcSession;
    } else {
      RTCSession rtcSession = connections[connectionId]!;
      print("_getConnection already is");

      /*if (rtcSession.rtcSessionStatus == RTCSessionStatus.failed) {
        rtcSession.dispose();
        await _createSession(remoteCoreId, remotePeerId);
      }*/
      return rtcSession;
    }
  }

  void _setRemotePeerId(ConnectionId connectionId, String? remotePeerId) {
    (connections[connectionId]!.remotePeer.remotePeerId == null &&
            remotePeerId != null)
        ? connections[connectionId]!.remotePeer.remotePeerId = remotePeerId
        : {};
  }

  Future<RTCSession> _createSession(ConnectionId connectionId,
      String remoteCoreId, String? remotePeerId) async {
    RTCSession rtcSession = await singleWebRTCConnection.createSession(
        connectionId, remoteCoreId, remotePeerId);
    connections[connectionId] = rtcSession;

    await rtcSession.createDataChannel();
    connections[connectionId] = rtcSession;
    onNewRTCSessionCreated?.call(rtcSession);
    _setRemotePeerId(connectionId, remotePeerId);
    return rtcSession;
  }

  // for preventing exception, always who has bigger coreId initiates the offer or starts the session
  Future<bool> initiateSession(String remoteCoreId, String selfCoreId) async {
    print(
        "initiateSession initiator is ${(selfCoreId.compareTo(remoteCoreId) > 0)}");

    if (selfCoreId.compareTo(remoteCoreId) > 0) {
      return await singleWebRTCConnection.startSession(
          await _getConnection(generateConnectionId(), remoteCoreId, null));
    } else {
      return await singleWebRTCConnection.initiateSession(remoteCoreId);
    }
  }

  onRequestReceived(Map<String, dynamic> mapData, String remoteCoreId,
      String remotePeerId) async {
    var data = mapData[DATA];
    print("onMessage, type: ${mapData['type']}");

    switch (mapData['type']) {
      case initiate:
        {
          RTCSession rtcSession = await _getConnection(
              generateConnectionId(), remoteCoreId, remotePeerId);
          singleWebRTCConnection.startSession(rtcSession);
        }
        break;
      case offer:
        {
          String connectionId = mapData[CONNECTION_ID];
          RTCSession rtcSession =
              await _getConnection(connectionId, remoteCoreId, remotePeerId);
          var description = data[DATA_DESCRIPTION];

          singleWebRTCConnection.onOfferReceived(rtcSession, description);
        }
        break;
      case answer:
        {
          String connectionId = mapData[CONNECTION_ID];
          RTCSession rtcSession =
              await _getConnection(connectionId, remoteCoreId, remotePeerId);
          var description = data[DATA_DESCRIPTION];
          singleWebRTCConnection.onAnswerReceived(rtcSession, description);
        }
        break;
      case candidate:
        {
          String connectionId = mapData[CONNECTION_ID];

          RTCSession rtcSession =
              await _getConnection(connectionId, remoteCoreId, remotePeerId);
          var candidateMap = data[candidate];
          singleWebRTCConnection.onCandidateReceived(rtcSession, candidateMap);
        }
        break;
    }
  }
}
