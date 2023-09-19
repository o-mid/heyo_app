class IncomingCallViewArguments {
  final String remotePeerId;
  final String remoteCoreId;
  final String callId;
  final bool isAudioCall;

  IncomingCallViewArguments(
      {
      required this.callId,
      required this.remotePeerId,
      required this.remoteCoreId,
      required this.isAudioCall});
}
