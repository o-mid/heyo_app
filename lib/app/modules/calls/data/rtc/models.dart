
import 'package:heyo/app/modules/calls/data/rtc/session/call_rtc_session.dart';

class CallSignalingCommands {
  static const candidate = 'candidate';
  static const offer = 'offer';
  static const answer = 'answer';
  static const request = 'request';
  static const reject = 'reject';
  static const newMember = 'newMemer';
  static const cameraStateChanged = 'cameraStateChanged';
}

CallId generateCallId() {
  return '${DateTime.now().millisecondsSinceEpoch}';
}

class RemotePeer {
  String remoteCoreId;
  String? remotePeerId;

  RemotePeer({required this.remoteCoreId, required this.remotePeerId});
}

typedef CallId = String;

class CurrentCall {
  final CallId callId;
  final List<CallRTCSession> sessions;

  CurrentCall({required this.callId, required this.sessions});
}

class CallInfo {
  RemotePeer remotePeer;
  bool isAudioCall;

  CallInfo({required this.remotePeer, required this.isAudioCall});
}

class RequestedCalls {
  final CallId callId;
  final List<CallInfo> remotePeers;

  RequestedCalls({required this.callId, required this.remotePeers});
}

class IncomingCalls {
  final CallId callId;
  final List<CallInfo> remotePeers;

  IncomingCalls({required this.callId, required this.remotePeers});
}