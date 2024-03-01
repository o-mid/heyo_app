
import 'package:heyo/modules/call/data/rtc/session/call_rtc_session.dart';

class CallSignalingCommands {
  static const candidate = 'candidate';
  static const offer = 'offer';
  static const answer = 'answer';

  static const initiate = 'initiate';
  static const request = 'request';
  static const reject = 'reject';
  static const leave = 'leave';
  static const newMember = 'newMemer';
  static const cameraStateChanged = 'cameraStateChanged';
}

CallId generateCallId() {
  return '${DateTime.now().millisecondsSinceEpoch}';
}

class RemotePeer {
  RemotePeer({required this.remoteCoreId, required this.remotePeerId});

  String remoteCoreId;
  String? remotePeerId;
}

typedef CallId = String;

class CurrentCall {
  CurrentCall({required this.callId, required this.sessions});

  final CallId callId;
  final List<CallRTCSession> sessions;
}

class CallInfo {
  CallInfo({required this.remotePeer, required this.isAudioCall});

  RemotePeer remotePeer;
  bool isAudioCall;
}

class RequestedCalls {
  RequestedCalls({required this.callId, required this.remotePeers});

  final CallId callId;
  final List<CallInfo> remotePeers;
}

class IncomingCalls {
  IncomingCalls({required this.callId, required this.remotePeers});

  final CallId callId;
  final List<CallInfo> remotePeers;
}
