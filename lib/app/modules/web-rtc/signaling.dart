import 'dart:convert';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:heyo/app/modules/connection/domain/connection_contractor.dart';
import 'package:heyo/app/modules/connection/domain/connection_models.dart';
import 'package:heyo/app/modules/messages/connection/models/models.dart';

enum CallState {
  callStateNew,
  callStateRinging,
  callStateInvite,
  callStateConnected,
  callStateBye,
  callStateClosedCamera,
  callStateOpendCamera,
}

class Session {
  Session({
    required this.sid,
    required this.cid,
    required this.pid,
    this.isAudioCall = false,
  });

  final String cid;
  final String sid;
  final String? pid;
  RTCPeerConnection? pc;
  RTCDataChannel? dc;

  final List<RTCIceCandidate> remoteCandidates = [];
  final bool isAudioCall;
}

class Signaling {
  final ConnectionContractor connectionContractor;
  final JsonEncoder _encoder = const JsonEncoder();
  final JsonDecoder _decoder = const JsonDecoder();

  Signaling({required this.connectionContractor}) {
    connectionContractor.getMessageStream().listen((event) {
      if (event is CallConnectionDataReceived) {
        onMessage(
          event.mapData,
          event.remoteCoreId,
          event.remotePeerId,
        );
      }
    });
  }

  final Map<String, Session> _sessions = {};
  MediaStream? _localStream;
  final List<MediaStream> _remoteStreams = <MediaStream>[];

  Function(Session session, CallState state)? onCallStateChange;
  Function(MediaStream stream)? onLocalStream;
  Function(Session session, MediaStream stream)? onAddRemoteStream;
  Function(Session session, MediaStream stream)? onRemoveRemoteStream;
  Function(Session session, RTCDataChannel dc, RTCDataChannelMessage data)? onDataChannelMessage;
  Function(Session session, RTCDataChannel dc)? onDataChannel;

  String get sdpSemantics => WebRTC.platformIsWindows ? 'plan-b' : 'unified-plan';

  final Map<String, dynamic> _iceServers = {
    'iceServers': [
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
        "credential": 'Sckjas86AVicubao9s8c7',
      }
    ],
  };

  final Map<String, dynamic> _config = {
    'mandatory': {},
    'optional': [
      {'DtlsSrtpKeyAgreement': true},
    ],
  };

  final Map<String, dynamic> _dcConstraints = {
    'mandatory': {
      'OfferToReceiveAudio': false,
      'OfferToReceiveVideo': false,
    },
    'optional': [],
  };

  Future<void> close() async {
    await _cleanSessions();
  }

  void switchCamera() {
    if (_localStream != null) {
      Helper.switchCamera(_localStream!.getVideoTracks()[0]);
    }
  }

  void muteMic() {
    if (_localStream != null) {
      var enabled = _localStream!.getAudioTracks()[0].enabled;
      _localStream!.getAudioTracks()[0].enabled = !enabled;
    }
  }

  void showLocalVideoStream(bool value) {
    if (_localStream != null) {
      _localStream!.getVideoTracks()[0].enabled = value;
    }
  }

  Future<Session> invite(
    String coreId,
    String media,
    bool useScreen,
    String selfId,
    bool isAudioCall,
  ) async {
    final sessionId = '$selfId-$coreId-${DateTime.now().millisecondsSinceEpoch}';

    var session = await _createSession(
      null,
      coreId: coreId,
      peerId: null,
      sessionId: sessionId,
      media: media,
      screenSharing: useScreen,
      isAudioCall: isAudioCall,
    );
    _sessions[sessionId] = session;
    if (media == 'data') {
      _createDataChannel(session);
    }
    _createOffer(session, media);
    onCallStateChange?.call(session, CallState.callStateNew);
    onCallStateChange?.call(session, CallState.callStateInvite);
    return session;
  }

  void peerOpendCamera(String sessionId) {
    var session = _sessions[sessionId] as Session;

    if (session != null) {
      _send(
        'opendcamera',
        {
          'session_id': sessionId,
        },
        session.cid,
        session.pid,
      );
    }
  }

  void peerClosedCamera(String sessionId) {
    Session session = _sessions[sessionId] as Session;

    if (session != null) {
      _send(
        'closedcamera',
        {
          'session_id': sessionId,
        },
        session.cid,
        session.pid,
      );
    }
  }

  void bye(Session session) {
    final sessionId = session.sid;
    Session sess = _sessions[sessionId] as Session;

    if (sess != null) {
      _closeSession(sess);
      _send(
        'bye',
        {
          'session_id': sessionId,
        },
        sess.cid,
        sess.pid,
      );
    }
  }

  void accept(String sessionId) {
    final session = _sessions[sessionId];
    print(sessionId);
    print("${_sessions.keys}");
    print("feafesfse ${session == null}");
    print("${_sessions.values}");

    if (session == null) {
      return;
    }

    _createAnswer(session, 'video');
  }

  void reject(Session session) {
    if (_sessions[session.sid] == null) {
      return;
    }
    bye(session);
  }

  void onMessage(Map<String, dynamic> mapData, String remoteCoreId, String remotePeerId) async {
    Map<String, dynamic> data = mapData['data'] as Map<String, dynamic>;
    print("onMessage, type: ${mapData['type']}");

    switch (mapData['type']) {
      case 'offer':
        {
          Map<String, dynamic> description = data['description'] as Map<String, dynamic>;
          var media = data['media'] as String;
          var sessionId = data['session_id'] as String;
          var session = _sessions[sessionId];
          var isAudioCall = data['isAudioCall'];
          var newSession = await _createSession(
            session,
            coreId: remoteCoreId,
            peerId: remotePeerId,
            sessionId: sessionId,
            media: media,
            screenSharing: false,
            isAudioCall: isAudioCall as bool,
          );
          _sessions[sessionId] = newSession;
          await newSession.pc?.setRemoteDescription(
            RTCSessionDescription(description['sdp'] as String, description['type'] as String),
          );
          // await _createAnswer(newSession, media);

          if (newSession.remoteCandidates.isNotEmpty) {
            for (var candidate in newSession.remoteCandidates) {
              await newSession.pc?.addCandidate(candidate);
            }
            newSession.remoteCandidates.clear();
          }

          onCallStateChange?.call(newSession, CallState.callStateNew);

          onCallStateChange?.call(newSession, CallState.callStateRinging);
        }
        break;
      case 'answer':
        {
          var description = data['description'] as Map<String, dynamic>;
          var sessionId = data['session_id'];
          var session = _sessions[sessionId] as Session?;
          await session?.pc?.setRemoteDescription(
            RTCSessionDescription(description['sdp'] as String, description['type'] as String),
          );
          onCallStateChange?.call(session!, CallState.callStateConnected);
        }
        break;
      case 'candidate':
        {
          var candidateMap = data['candidate'] as Map<String, dynamic>;
          var sessionId = data['session_id'] as String;
          var session = _sessions[sessionId];
          var candidate = RTCIceCandidate(
            candidateMap['candidate'] as String,
            candidateMap['sdpMid'] as String,
            candidateMap['sdpMLineIndex'] as int?,
          );

          if (session != null) {
            if (session.pc != null) {
              await session.pc?.addCandidate(candidate);
            } else {
              session.remoteCandidates.add(candidate);
            }
          } else {
            _sessions[sessionId] = Session(
              cid: remoteCoreId,
              sid: sessionId,
              pid: remotePeerId,
            )..remoteCandidates.add(candidate);
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
          var sessionId = data['session_id'] as String;
          var session = _sessions.remove(sessionId);
          print('bye: ' + sessionId + ' ${(session != null)}');

          if (session != null) {
            onCallStateChange?.call(session, CallState.callStateBye);
            _closeSession(session);
          }
        }
        break;
      case 'keepalive':
        {
          print('keepalive response!');
        }
        break;

      case "closedcamera":
        {
          var sessionId = data['session_id'];
          var session = _sessions[sessionId] as Session;
          if (session != null) {
            onCallStateChange?.call(session, CallState.callStateClosedCamera);
          }
        }
        break;
      case "opendcamera":
        {
          var sessionId = data['session_id'];
          var session = _sessions[sessionId] as Session;
          if (session != null) {
            onCallStateChange?.call(session, CallState.callStateOpendCamera);
          }
        }
        break;
      default:
        break;
    }
  }

  Future<MediaStream> createStream(String media, bool userScreen) async {
    final mediaConstraints = <String, dynamic>{
      'audio': userScreen ? false : true,
      'video': userScreen
          ? true
          : {
              'mandatory': {
                'minWidth': '640',
                // Provide your own width, height and frame rate here
                'minHeight': '480',
                'minFrameRate': '30',
              },
              'facingMode': 'user',
              'optional': [],
            },
    };

    var stream = userScreen
        ? await navigator.mediaDevices.getDisplayMedia(mediaConstraints)
        : await navigator.mediaDevices.getUserMedia(mediaConstraints);
    onLocalStream?.call(stream);
    return stream;
  }

  Future<Session> _createSession(
    Session? session, {
    required String coreId,
    required String? peerId,
    required String sessionId,
    required String media,
    required bool screenSharing,
    required bool isAudioCall,
  }) async {
    var newSession =
        session ?? Session(sid: sessionId, cid: coreId, pid: peerId, isAudioCall: isAudioCall);
    if (media != 'data') {
      _localStream = await createStream(media, screenSharing);
    }
    print(_iceServers);
    var pc = await createPeerConnection(
      {
        ..._iceServers,
        ...{'sdpSemantics': sdpSemantics},
      },
      _config,
    );
    if (media != 'data') {
      switch (sdpSemantics) {
        case 'plan-b':
          pc.onAddStream = (MediaStream stream) {
            onAddRemoteStream?.call(newSession, stream);
            _remoteStreams.add(stream);
          };
          await pc.addStream(_localStream!);
          break;
        case 'unified-plan':
          // Unified-Plan
          pc.onTrack = (event) {
            if (event.track.kind == 'video') {
              onAddRemoteStream?.call(newSession, event.streams[0]);
            }
          };
          _localStream!.getTracks().forEach((track) {
            pc.addTrack(track, _localStream!);
          });
          break;
      }
    }
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
          peerId,
        ),
      );
    };

    pc.onIceConnectionState = (state) {};

    pc.onRemoveStream = (stream) {
      onRemoveRemoteStream?.call(newSession, stream);
      _remoteStreams.removeWhere((it) {
        return (it.id == stream.id);
      });
    };

    pc.onDataChannel = (channel) {
      _addDataChannel(newSession, channel);
    };

    newSession.pc = pc;
    return newSession;
  }

  void _addDataChannel(Session session, RTCDataChannel channel) {
    channel.onDataChannelState = (e) {};
    channel.onMessage = (RTCDataChannelMessage data) {
      onDataChannelMessage?.call(session, channel, data);
    };
    session.dc = channel;
    onDataChannel?.call(session, channel);
  }

  Future<void> _createDataChannel(Session session, {label = 'fileTransfer'}) async {
    var dataChannelDict = RTCDataChannelInit()..maxRetransmits = 30;
    var channel = await session.pc!.createDataChannel(label as String, dataChannelDict);
    _addDataChannel(session, channel);
  }

  Future<void> _createOffer(Session session, String media) async {
    try {
      var s = await session.pc!.createOffer(media == 'data' ? _dcConstraints : {});
      await session.pc!.setLocalDescription(s);
      _send(
        'offer',
        {
          'to': session.cid,
          'description': {'sdp': s.sdp, 'type': s.type},
          'session_id': session.sid,
          'media': media,
          "isAudioCall": session.isAudioCall,
        },
        session.cid,
        session.pid,
      );
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _createAnswer(Session session, String media) async {
    try {
      var s = await session.pc!.createAnswer(media == 'data' ? _dcConstraints : {});
      await session.pc!.setLocalDescription(s);
      _send(
        'answer',
        {
          'to': session.cid,
          'description': {'sdp': s.sdp, 'type': s.type},
          'session_id': session.sid,
        },
        session.cid,
        session.pid,
      );
    } catch (e) {
      print(e.toString());
    }
  }

  _send(event, data, String remoteCoreId, String? remotePeerId) {
    var request = {};
    request["type"] = event;
    request["data"] = data;
    request["command"] = "call";
    debugPrint("Sending Request : " + request.toString());
    connectionContractor.sendMessage(_encoder.convert(request),
        RemotePeer(remoteCoreId: remoteCoreId, remotePeerId: remotePeerId));
  }

  Future<void> _cleanSessions() async {
    if (_localStream != null) {
      _localStream!.getTracks().forEach((element) async {
        await element.stop();
      });
      await _localStream!.dispose();
      _localStream = null;
    }
    _sessions.forEach((key, sess) async {
      await sess.pc?.close();
      await sess.dc?.close();
    });
    _sessions.clear();
  }

  void _closeSessionByPeerId(String peerId) {
    var session;
    _sessions.removeWhere((String key, Session sess) {
      final ids = key.split('-');
      session = sess;
      return peerId == ids[0] || peerId == ids[1];
    });
    if (session != null) {
      _closeSession(session as Session);
      onCallStateChange?.call(session as Session, CallState.callStateBye);
    }
  }

  Future<void> _closeSession(Session session) async {
    _localStream?.getTracks().forEach((element) async {
      await element.stop();
    });
    await _localStream?.dispose();
    _localStream = null;

    await session.pc?.close();
    await session.dc?.close();
  }
}
