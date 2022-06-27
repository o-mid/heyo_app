class IncomingCallViewArguments {
  final String sdp;
  final String remotePeerId;
  final String remoteCoreId;
  final String callId;

  IncomingCallViewArguments(
      {required this.callId,
      required this.sdp,
      required this.remotePeerId,
      required this.remoteCoreId});
}
