class CallState {
  CallState._();

  factory CallState.callReceived(String session, String eventId,
      String remoteCoreId, String remotePeerId) = CallReceivedState;

  factory CallState.none() = NoneState;

  factory CallState.calling() = Calling;

  factory CallState.callAccepted(String session, String eventId,
      String remoteCoreId, String remotePeerId) = CallAccepted;
}

class CallAccepted extends CallState {
  CallAccepted(this.session, this.eventId, this.remoteCoreId, this.remotePeerId)
      : super._();

  final String session;
  final String eventId;
  final String remoteCoreId;
  final String remotePeerId;
}

class NoneState extends CallState {
  NoneState() : super._();
}

class Calling extends CallState {
  Calling() : super._();
}

class CallReceivedState extends CallState {
  CallReceivedState(
      this.session, this.eventId, this.remoteCoreId, this.remotePeerId)
      : super._();

  final String session;
  final String eventId;
  final String remoteCoreId;
  final String remotePeerId;
}
