class CallState {
  CallState._();

  factory CallState.callReceived(String session,
      String remoteCoreId, String remotePeerId) = CallReceivedState;

  factory CallState.none() = NoneState;

  factory CallState.calling() = Calling;

  factory CallState.callAccepted(
      String session, String remoteCoreId, String remotePeerId) = CallAccepted;

  factory CallState.inCall() = InCall;

  factory CallState.ended() = CallEnded;
}

class InCall extends CallState {
  InCall() : super._();
}

class CallAccepted extends CallState {
  CallAccepted(this.session, this.remoteCoreId, this.remotePeerId) : super._();

  final String session;
  final String remoteCoreId;
  final String remotePeerId;
}

class CallEnded extends CallState {
  CallEnded() : super._();
}

class NoneState extends CallState {
  NoneState() : super._();
}

class Calling extends CallState {
  Calling() : super._();
}

class CallReceivedState extends CallState {
  CallReceivedState(
      this.session, this.remoteCoreId, this.remotePeerId)
      : super._();

  final String session;
  final String remoteCoreId;
  final String remotePeerId;
}
