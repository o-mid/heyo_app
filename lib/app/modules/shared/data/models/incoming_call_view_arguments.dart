class IncomingCallViewArguments {
  final String session;
  final String remotePeerId;
  final String remoteCoreId;
  final String eventId;

  IncomingCallViewArguments(
      {required this.eventId,
      required this.session,
      required this.remotePeerId,
      required this.remoteCoreId});
}
