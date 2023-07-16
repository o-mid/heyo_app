import 'package:heyo/app/modules/messaging/models.dart';
import 'package:heyo/app/modules/messaging/single_webrtc_connection.dart';

class MultipleConnectionHandler {
  Map<ConnectionId, RTCSession> connections = {};
  final SingleWebRTCConnection singleWebRTCConnection;
  Function(RTCSession)? onNewRTCSessionCreated;
  Function(RTCSession)? onRTCSessionConnected;

  MultipleConnectionHandler({required this.singleWebRTCConnection});

  Future<RTCSession> getConnection(
      String remoteCoreId, String selfCoreId) async {
    print("getConnection : $remoteCoreId");
    connections.forEach((key, value) {
      print(
          "getConnection : ${value.remotePeer.remoteCoreId} : ${value.connectionId} :  ${value.rtcSessionStatus}");
    });

    RTCSession? rtcSession = getLatestRemoteConnections(remoteCoreId);
    if (rtcSession != null) {
      _removePrevConnections(remoteCoreId, rtcSession.connectionId);
      if (rtcSession.rtcSessionStatus == RTCSessionStatus.failed ||
          rtcSession.rtcSessionStatus == RTCSessionStatus.none) {
        connections[rtcSession.connectionId]?.dispose();
        connections.remove(rtcSession.connectionId);
        rtcSession = await _initiateSession(remoteCoreId, selfCoreId);
      }
    } else {
      rtcSession = await _initiateSession(remoteCoreId, selfCoreId);
    }

    return rtcSession;
  }

  initiateConnections(String remoteCoreId, String selfCoreId) {
    _initiateSession(remoteCoreId, selfCoreId);
  }

  reset() {
    connections.forEach((key, value) {
      connections[key]?.dispose();
    });
    connections.clear();
  }

  _removePeerConnections(String remoteCoreId) {
    List<RTCSession> items = connections.values
        .where((element) => (element.remotePeer.remoteCoreId == remoteCoreId))
        .toList();
    for (var element in items) {
      connections[element.connectionId]?.dispose();
      connections.remove(element.connectionId);
    }
  }

  _removePrevConnections(String remoteCoreId, ConnectionId connectionId) {
    List<RTCSession> items = connections.values
        .where((element) => (element.remotePeer.remoteCoreId == remoteCoreId &&
            element.connectionId != connectionId))
        .toList();
    for (var element in items) {
      connections[element.connectionId]?.dispose();

      connections.remove(element.connectionId);
    }
  }

  RTCSession? getLatestRemoteConnections(String remoteCoreId) {
    List<RTCSession> items = connections.values
        .where((element) => element.remotePeer.remoteCoreId == remoteCoreId)
        .toList();
    items.sort((a, b) => a.timeStamp.compareTo(b.timeStamp));
    if (items.isEmpty) {
      return null;
    }

    return items.last;
  }

  Future<RTCSession> _getConnection(
    ConnectionId connectionId,
    String remoteCoreId,
    String? remotePeerId,
  ) async {
    print("_getConnection");
    if (connections[connectionId] == null) {
      _removePeerConnections(remoteCoreId);
      RTCSession rtcSession =
          await _createSession(connectionId, remoteCoreId, remotePeerId);
      print("_getConnection new created");

      return rtcSession;
    } else {
      RTCSession rtcSession = getLatestRemoteConnections(remoteCoreId)!;
      if (rtcSession.connectionId == connectionId) {
        _removePrevConnections(remoteCoreId, connectionId);
        print("_getConnection the latest");

        return connections[connectionId]!;
      } else {
        print("_getConnection deprecated");

        _removePeerConnections(remoteCoreId);
        return await _createSession(connectionId, remoteCoreId, remotePeerId);
      }
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

    rtcSession.onRTCSessionConnected = (rtc) {
      onRTCSessionConnected?.call(rtc);
    };
    connections[connectionId] = rtcSession;
    onNewRTCSessionCreated?.call(rtcSession);
    _setRemotePeerId(connectionId, remotePeerId);
    return rtcSession;
  }

  // for preventing exception, always who has bigger coreId initiates the offer or starts the session
  Future<RTCSession> _initiateSession(
      String remoteCoreId, String selfCoreId) async {
    print(
        "initiateSession initiator is ${(selfCoreId.compareTo(remoteCoreId) > 0)}");
    RTCSession rtcSession =
        await _getConnection(generateConnectionId(), remoteCoreId, null);

    if (selfCoreId.compareTo(remoteCoreId) > 0) {
      singleWebRTCConnection.startSession(rtcSession);
    } else {
      singleWebRTCConnection.initiateSession(rtcSession);
    }

    return rtcSession;
  }

  onRequestReceived(Map<String, dynamic> mapData, String remoteCoreId,
      String remotePeerId) async {
    var data = mapData[DATA];
    print("onMessage, type: ${mapData['type']}");

    switch (mapData['type']) {
      case initiate:
        {
          String connectionId = mapData[CONNECTION_ID];

          RTCSession rtcSession =
              await _getConnection(connectionId, remoteCoreId, remotePeerId);
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
