class IncomingCallViewArguments {
  final String remotePeerId;
  final String remoteCoreId;
  final String callId;
  final String? name;
  final bool isAudioCall;

  IncomingCallViewArguments(
      {
      required this.callId,
      required this.remotePeerId,
      required this.remoteCoreId,
      required this.name,
      required this.isAudioCall});
}
