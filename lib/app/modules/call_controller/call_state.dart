class CallState {
  CallState._();

  factory CallState.callReceived(String session, String eventId) =
      CallReceivedState;

  factory CallState.none() = NoneState;


}

class NoneState extends CallState {
  NoneState() : super._();
}

class CallReceivedState extends CallState {
  CallReceivedState(this.session, this.eventId) : super._();

  final String session;
  final String eventId;
}
