
// 1)none, 2)calling, 3)callAccepted, 4)inCall
// 1)none, 2)callReceived, 3)inCall
class CallState {
  CallState._();

  factory CallState.callReceived(String callId, String session,
      String remoteCoreId, String remotePeerId) = CallReceivedState;

  factory CallState.none() = NoneState;

  factory CallState.calling(String callId) = Calling;

  factory CallState.callAccepted(String callId, String session,
      String remoteCoreId, String remotePeerId) = CallAccepted;

  factory CallState.inCall(String callId) = InCall;

  factory CallState.ended(String callId) = CallEnded;
}



class InCall extends CallState {
  InCall(this.callId) : super._();
  final String callId;
}

class CallAccepted extends CallState {
  CallAccepted(this.callId, this.session, this.remoteCoreId, this.remotePeerId)
      : super._();

  final String callId;
  final String session;
  final String remoteCoreId;
  final String remotePeerId;
}

class CallEnded extends CallState {
  CallEnded(this.callId) : super._();
  final String callId;
}

class NoneState extends CallState {
  NoneState() : super._();
}

class Calling extends CallState {
  Calling(this.callId) : super._();
  final String callId;
}

class CallReceivedState extends CallState {
  CallReceivedState(
      this.callId, this.session, this.remoteCoreId, this.remotePeerId)
      : super._();

  final String callId;
  final String session;
  final String remoteCoreId;
  final String remotePeerId;
}
