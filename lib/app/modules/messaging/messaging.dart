import 'dart:convert';
import 'dart:async';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:heyo/app/modules/messaging/messaging_session.dart';
import 'package:heyo/app/modules/p2p_node/p2p_communicator.dart';

//TODO messaging: refactor
enum ConnectionStatus {
  CONNECTING,
  NEW,
  INVITE,
  CONNECTED,
  RINGING,
  BYE,
}

class Messaging {
  final P2PCommunicator p2pCommunicator;
  final JsonEncoder _encoder = const JsonEncoder();

  Messaging({required this.p2pCommunicator});

  final Map<String, MessageSession> _sessions = {};

  Map<String, MessageSession> getSessions() {
    return _sessions;
  }

  Function(MessageSession session, ConnectionStatus status)? onMessageStateChange;

  Function(MessageSession session, RTCDataChannel dc, RTCDataChannelMessage data)?
      onDataChannelMessage;
  Function(MessageSession session, RTCDataChannel dc)? onDataChannel;

  final Map<String, dynamic> _iceServers = {
    'iceServers': [
      {'url': 'stun:stun.l.google.com:19302'},
      {
        "url": 'turn:77.73.67.64:3478',
        "username": 'turn-demo-server',
        "credential": 'coiansliocuna89s7ca',
      }
    ]
  };

  final Map<String, dynamic> _config = {
    'mandatory': {},
    'optional': [
      {'DtlsSrtpKeyAgreement': true},
    ]
  };

  final Map<String, dynamic> _dcConstraints = {
    'mandatory': {
      'OfferToReceiveAudio': false,
      'OfferToReceiveVideo': false,
    },
    'optional': [],
  };

  close() async {
    await _cleanSessions();
  }

  Future<MessageSession> connectionRequest(
      String coreId, String media, bool useScreen, String selfId) async {
    final sessionId = '$selfId-$coreId-${DateTime.now().millisecondsSinceEpoch}';
    MessageSession session = await _createSession(
      null,
      coreId: coreId,
      peerId: null,
      sessionId: sessionId,
      media: media,
      screenSharing: useScreen,
    );
    _sessions[sessionId] = session;
    _createDataChannel(session);
    _createOffer(session, media);

    onMessageStateChange?.call(session, ConnectionStatus.NEW);
    onMessageStateChange?.call(session, ConnectionStatus.INVITE);

    return session;
  }

  void onMessage(mapData, String remoteCoreId, String remotePeerId) async {
    var data = mapData['data'];
    print("onMessage, type: ${mapData['type']}");

    switch (mapData['type']) {
      case 'offer':
        {
          var description = data['description'];
          var media = data['media'];
          var sessionId = data['session_id'];
          var session = _sessions[sessionId];
          var newSession = await _createSession(session,
              coreId: remoteCoreId,
              peerId: remotePeerId,
              sessionId: sessionId,
              media: media,
              screenSharing: false);
          _sessions[sessionId] = newSession;
          await newSession.pc?.setRemoteDescription(
              RTCSessionDescription(description['sdp'], description['type']));

          //    await _createAnswer(newSession, media);

          if (newSession.remoteCandidates.isNotEmpty) {
            for (var candidate in newSession.remoteCandidates) {
              await newSession.pc?.addCandidate(candidate);
            }
            newSession.remoteCandidates.clear();
          }

          onMessageStateChange?.call(newSession, ConnectionStatus.NEW);
          onMessageStateChange?.call(newSession, ConnectionStatus.RINGING);
        }
        break;
      case 'answer':
        {
          var description = data['description'];
          var sessionId = data['session_id'];
          var session = _sessions[sessionId];
          session?.pc?.setRemoteDescription(
              RTCSessionDescription(description['sdp'], description['type']));
          onMessageStateChange?.call(session!, ConnectionStatus.CONNECTED);
        }
        break;
      case 'candidate':
        {
          var candidateMap = data['candidate'];
          var sessionId = data['session_id'];
          var session = _sessions[sessionId];
          RTCIceCandidate candidate = RTCIceCandidate(
              candidateMap['candidate'], candidateMap['sdpMid'], candidateMap['sdpMLineIndex']);

          if (session != null) {
            if (session.pc != null) {
              await session.pc?.addCandidate(candidate);
            } else {
              session.remoteCandidates.add(candidate);
            }
          } else {
            _sessions[sessionId] =
                MessageSession(cid: remoteCoreId, sid: sessionId, pid: remotePeerId)
                  ..remoteCandidates.add(candidate);
          }
        }
        break;
      case 'leave':
        {
          var peerId = data as String;
          _closeSessionByPeerId(peerId);
        }
        break;
      case 'bye':
        {
          var sessionId = data['session_id'];
          var session = _sessions.remove(sessionId);
          print('bye: ' + sessionId + ' ${(session != null)}');

          if (session != null) {
            onMessageStateChange?.call(session, ConnectionStatus.BYE);
            _closeSession(session);
          }
        }
        break;
      case 'keepalive':
        {
          print('keepalive response!');
        }
        break;
      default:
        break;
    }
  }

  void bye(String sessionId) {
    var sess = _sessions[sessionId];

    if (sess != null) {
      _closeSession(sess);
      _send(
          'bye',
          {
            'session_id': sessionId,
          },
          sess.cid,
          sess.pid);
    }
  }

  Future<MessageSession> _createSession(MessageSession? session,
      {required String coreId,
      required String? peerId,
      required String sessionId,
      required String media,
      required bool screenSharing}) async {
    var newSession = session ?? MessageSession(sid: sessionId, cid: coreId, pid: peerId);

    print(_iceServers);
    RTCPeerConnection pc = await createPeerConnection({
      ..._iceServers,
      ...{'sdpSemantics': "unified-plan"}
    }, _config);
    pc.onIceCandidate = (candidate) async {
      if (candidate == null) {
        print('onIceCandidate: complete!');
        return;
      }
      // This delay is needed to allow enough time to try an ICE candidate
      // before skipping to the next one. 1 second is just an heuristic value
      // and should be thoroughly tested in your own environment.
      await Future.delayed(
          const Duration(seconds: 1),
          () => _send(
              'candidate',
              {
                'to': peerId,
                'candidate': {
                  'sdpMLineIndex': candidate.sdpMLineIndex,
                  'sdpMid': candidate.sdpMid,
                  'candidate': candidate.candidate,
                },
                'session_id': sessionId,
              },
              coreId,
              peerId));
    };

    pc.onIceConnectionState = (state) {};

    // pc.onRemoveStream = (stream) {
    //   //Todo farzam
    //   //onRemoveRemoteStream?.call(newSession, stream);
    // };

    pc.onDataChannel = (channel) {
      _addDataChannel(newSession, channel);
    };

    newSession.pc = pc;
    return newSession;
  }

  void _addDataChannel(MessageSession session, RTCDataChannel channel) {
    channel.onMessage = (RTCDataChannelMessage data) {
      onDataChannelMessage?.call(session, channel, data);
    };
    session.dc.value = channel;
    onDataChannel?.call(session, channel);
  }

  Future<void> _createDataChannel(MessageSession session, {label = 'fileTransfer'}) async {
    RTCDataChannelInit dataChannelDict = RTCDataChannelInit()..maxRetransmits = 30;
    RTCDataChannel channel = await session.pc!.createDataChannel(label, dataChannelDict);
    _addDataChannel(session, channel);
  }

  Future<void> _createOffer(MessageSession session, String media) async {
    try {
      RTCSessionDescription s =
          await session.pc!.createOffer(media == 'data' ? _dcConstraints : {});
      await session.pc!.setLocalDescription(s);
      _send(
          'offer',
          {
            'to': session.cid,
            'description': {'sdp': s.sdp, 'type': s.type},
            'session_id': session.sid,
            'media': media,
          },
          session.cid,
          session.pid);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _createAnswer(MessageSession session, String media) async {
    try {
      RTCSessionDescription s =
          await session.pc!.createAnswer(media == 'data' ? _dcConstraints : {});
      await session.pc!.setLocalDescription(s);
      _send(
          'answer',
          {
            'to': session.cid,
            'description': {'sdp': s.sdp, 'type': s.type},
            'session_id': session.sid,
          },
          session.cid,
          session.pid);
    } catch (e) {
      print(e.toString());
    }
  }

  _send(event, data, remoteCoreId, remotePeerId) {
    var request = {};
    request["type"] = event;
    request["data"] = data;
    request["command"] = "message";
    p2pCommunicator.sendSDP(_encoder.convert(request), remoteCoreId, remotePeerId);
  }

  Future<void> _cleanSessions() async {
    _sessions.forEach((key, sess) async {
      await sess.pc?.close();
      await sess.dc.value?.close();
    });
    _sessions.clear();
  }

  void _closeSessionByPeerId(String peerId) {
    var session;
    _sessions.removeWhere((String key, MessageSession sess) {
      final ids = key.split('-');
      session = sess;
      return peerId == ids[0] || peerId == ids[1];
    });
    if (session != null) {
      _closeSession(session);
      onMessageStateChange?.call(session, ConnectionStatus.BYE);
    }
  }

  Future<void> _closeSession(MessageSession session) async {
    await session.pc?.close();
    await session.dc.value?.close();
  }

  void sendMessage(String message) {
    //da
  }
  Future<void> accept(String sessionId) async {
    MessageSession? session = _sessions[sessionId];
    print(sessionId);
    print("${_sessions.keys}");
    print("feafesfse ${session == null}");
    print("${_sessions.values}");

    if (session == null) {
      return;
    }

    await _createAnswer(session, 'data');
  }
}
