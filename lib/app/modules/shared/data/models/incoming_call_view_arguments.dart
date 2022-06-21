class IncomingCallViewArguments {
  final String sdp;
  final String remotePeerId;
  final String remoteCoreId;

  IncomingCallViewArguments(
      {
      required this.sdp,
      required this.remotePeerId,
      required this.remoteCoreId});
}
