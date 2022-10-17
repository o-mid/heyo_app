import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';

class MessageSession {
  MessageSession({required this.sid, required this.cid, required this.pid});

  /// remoteCoreId
  final String cid;

  /// sessionId
  final String sid;

  /// remotePeerId
  final String? pid;
  RTCPeerConnection? pc;
  Rxn<RTCDataChannel> dc = Rxn();
  final List<RTCIceCandidate> remoteCandidates = [];
}
