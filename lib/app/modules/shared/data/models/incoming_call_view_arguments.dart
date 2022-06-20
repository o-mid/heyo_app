class IncomingCallViewArguments {
  final String session;
  final String remotePeerId;
  final String remoteCoreId;

  IncomingCallViewArguments(
      {
      required this.session,
      required this.remotePeerId,
      required this.remoteCoreId});
}
